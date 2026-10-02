"""Extract a child-size India canvas from Natural Earth 50m.

Natural Earth is public domain. This script does not redraw borders for
decoration. It only extracts India, projects to a 0-1 canvas, and
simplifies rings so they stay tappable on a phone.
"""

from __future__ import annotations

import json
import math
from pathlib import Path

ADMIN1 = Path(r"C:\Users\MSUSERSL123\AppData\Local\Temp\ne_50m_admin1.geojson")
ADMIN0 = Path(r"C:\Users\MSUSERSL123\AppData\Local\Temp\ne_50m_admin0.geojson")
OUT = Path(r"C:\Users\MSUSERSL123\Documents\kidsApp\assets\content\geography\slice_geometry.json")

# Keep enough points for a recognizable outline without a huge pack.
TOLERANCE = 0.012
MIN_POINTS = 8
SMALL_SPAN = 0.055


def rings_of(geom: dict) -> list[list[list[float]]]:
    kind = geom["type"]
    if kind == "Polygon":
        return geom["coordinates"]
    if kind == "MultiPolygon":
        rings = []
        for polygon in geom["coordinates"]:
            rings.extend(polygon)
        return rings
    raise ValueError(kind)


def bbox_of(rings: list[list[list[float]]]) -> tuple[float, float, float, float]:
    xs = [p[0] for ring in rings for p in ring]
    ys = [p[1] for ring in rings for p in ring]
    return min(xs), min(ys), max(xs), max(ys)


def area_ring(ring: list[list[float]]) -> float:
    total = 0.0
    for i, (x1, y1) in enumerate(ring):
        x2, y2 = ring[(i + 1) % len(ring)]
        total += x1 * y2 - x2 * y1
    return abs(total) / 2


def keep_main_rings(rings: list[list[list[float]]], keep: int = 3) -> list[list[list[float]]]:
    ranked = sorted(rings, key=area_ring, reverse=True)
    main = ranked[:keep]
    return [ring for ring in main if area_ring(ring) >= area_ring(main[0]) * 0.008 or ring is main[0]]


def perp_dist(point, start, end) -> float:
    x, y = point
    x1, y1 = start
    x2, y2 = end
    dx, dy = x2 - x1, y2 - y1
    length = math.hypot(dx, dy)
    if length == 0:
        return math.hypot(x - x1, y - y1)
    return abs((x - x1) * dy - (y - y1) * dx) / length


def rdp(points: list[list[float]], tolerance: float) -> list[list[float]]:
    if len(points) < 3:
        return points
    start, end = points[0], points[-1]
    farthest = 0
    index = 0
    for i in range(1, len(points) - 1):
        distance = perp_dist(points[i], start, end)
        if distance > farthest:
            farthest = distance
            index = i
    if farthest > tolerance:
        left = rdp(points[: index + 1], tolerance)
        right = rdp(points[index:], tolerance)
        return left[:-1] + right
    return [start, end]


def simplify(ring: list[list[float]]) -> list[list[float]]:
    closed = ring[0] == ring[-1]
    body = ring[:-1] if closed else ring
    simple = rdp(body, TOLERANCE)
    if len(simple) < MIN_POINTS:
        step = max(1, len(body) // MIN_POINTS)
        simple = body[::step]
    if closed:
        if simple[0] != simple[-1]:
            simple = simple + [simple[0]]
    return [[round(x, 4), round(y, 4)] for x, y in simple]


def project(lon: float, lat: float, west: float, south: float, east: float, north: float) -> list[float]:
    width = east - west
    height = north - south
    return [round((lon - west) / width, 4), round(1 - (lat - south) / height, 4)]


def project_rings(rings, west, south, east, north):
    return [[project(lon, lat, west, south, east, north) for lon, lat in ring] for ring in rings]


def centroid(rings):
    ring = max(rings, key=area_ring)
    xs = [p[0] for p in ring]
    ys = [p[1] for p in ring]
    return [round(sum(xs) / len(xs), 4), round(sum(ys) / len(ys), 4)]


def span_box(rings):
    minx, miny, maxx, maxy = bbox_of(rings)
    return [round(minx, 4), round(miny, 4), round(maxx, 4), round(maxy, 4)]


def load_india_country():
    data = json.loads(ADMIN0.read_text(encoding="utf-8"))
    for feat in data["features"]:
        props = feat["properties"]
        if props.get("ADM0_A3") == "IND" or props.get("ADMIN") == "India":
            return keep_main_rings(rings_of(feat["geometry"]), keep=4)
    raise SystemExit("India country outline missing")


def load_india_admin1():
    data = json.loads(ADMIN1.read_text(encoding="utf-8"))
    regions = []
    for feat in data["features"]:
        props = feat["properties"]
        if props.get("adm0_a3") != "IND":
            continue
        regions.append((props["name_en"] or props["name"], feat["geometry"]))
    return regions


def main() -> None:
    country_lonlat = load_india_country()
    admin1 = load_india_admin1()
    west, south, east, north = bbox_of(country_lonlat)
    # Pad slightly so coastal states are not clipped.
    pad_x = (east - west) * 0.02
    pad_y = (north - south) * 0.02
    west, east = west - pad_x, east + pad_x
    south, north = south - pad_y, north + pad_y

    country = [simplify(ring) for ring in project_rings(country_lonlat, west, south, east, north)]
    regions = []
    for name, geom in admin1:
        lonlat = keep_main_rings(rings_of(geom), keep=3)
        rings = [simplify(ring) for ring in project_rings(lonlat, west, south, east, north)]
        box = span_box(rings)
        regions.append(
            {
                "id": slug(name),
                "name": name,
                "rings": rings,
                "centroid": centroid(rings),
                "bbox": box,
                "smallTarget": (box[2] - box[0]) < SMALL_SPAN or (box[3] - box[1]) < SMALL_SPAN,
            }
        )

    payload = {
        "packId": "geography_dev_slice",
        "schemaVersion": 1,
        "reviewStatus": "PLACEHOLDER",
        "source": {
            "name": "Natural Earth Admin 0 and Admin 1, 1:50m",
            "url": "https://www.naturalearthdata.com/downloads/50m-cultural-vectors/",
            "files": [
                "ne_50m_admin_0_countries.geojson",
                "ne_50m_admin_1_states_provinces.geojson",
            ],
            "license": "Public Domain (Natural Earth terms of use)",
            "licenseUrl": "https://www.naturalearthdata.com/about/terms-of-use/",
            "retrievedAt": "2026-10-03",
            "modifications": "India extracted, projected to a 0-1 canvas, and simplified with Ramer-Douglas-Peucker. Borders were not moved for decoration. Natural Earth type labels are not used as official state/UT types.",
            "rightsReview": "pending_owner_and_geography_review",
            "note": "This is not a Survey of India map and is not an official boundary product for publication in India until a reviewer accepts the source.",
        },
        "canvas": {
            "west": round(west, 4),
            "south": round(south, 4),
            "east": round(east, 4),
            "north": round(north, 4),
        },
        "country": {"rings": country},
        "regions": sorted(regions, key=lambda item: item["name"]),
    }
    OUT.parent.mkdir(parents=True, exist_ok=True)
    OUT.write_text(json.dumps(payload, ensure_ascii=True, separators=(",", ":")), encoding="utf-8")
    print("regions", len(regions), "bytes", OUT.stat().st_size)
    small = [item["name"] for item in regions if item["smallTarget"]]
    print("small", small)


def slug(name: str) -> str:
    return "in-" + "".join(ch.lower() if ch.isalnum() else "-" for ch in name).strip("-")


if __name__ == "__main__":
    main()
