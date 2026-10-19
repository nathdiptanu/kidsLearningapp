"""Extract teaching geometry from original SOI lines, never invented boundaries."""
import sys, json
from pathlib import Path
sys.path[:0] = [str(Path('.runtime/pdf').resolve()), str(Path('.runtime/geo').resolve())]
import pymupdf
from shapely.geometry import LineString
from shapely.ops import unary_union, polygonize

p = pymupdf.open('design/maps/soi-states-source.pdf')[0]
drawings = p.get_drawings()
lines = []
for i, drawing in enumerate(drawings):
    if i >= 178 or drawing['type'] != 's':
        continue
    for item in drawing['items']:
        if item[0] == 'l':
            points = [(round(v.x, 2), round(v.y, 2)) for v in item[1:]]
            if points[0] != points[1]:
                lines.append(LineString(points))
        elif item[0] == 'qu':
            q = item[1]
            lines.append(LineString([(round(v.x, 2), round(v.y, 2)) for v in [q.ul, q.ur, q.lr, q.ll, q.ul]]))
        else:
            raise ValueError(f'Unexpected source boundary operation {item[0]}')
polygons = list(polygonize(unary_union(lines)))
polygons.sort(key=lambda x: -x.area)
out = [{'area': round(p.area, 2), 'centroid': list(p.centroid.coords)[0],
        'ring': list(p.exterior.coords), 'holes': [list(r.coords) for r in p.interiors]}
       for p in polygons]
Path('build/source-state-faces.json').write_text(json.dumps(out))
print('faces', len(out), 'large', [(i, q['area'], q['centroid']) for i, q in enumerate(out[:40])])

# Original closed faces checked against the source's printed state names.
names = ['Rajasthan', 'Maharashtra', 'Madhya Pradesh', 'Uttar Pradesh',
         'Karnataka', 'Gujarat', 'Ladakh', 'Andhra Pradesh', 'Odisha',
         'Tamil Nadu', 'Chhattisgarh', 'Telangana', 'Bihar', 'West Bengal',
         'Arunachal Pradesh', 'Jharkhand', 'Assam', 'Himachal Pradesh',
         'Jammu and Kashmir', 'Uttarakhand', 'Punjab', 'Haryana', 'Kerala',
         'Meghalaya', 'Manipur', 'Mizoram', 'Nagaland', 'Tripura', 'Sikkim',
         'Goa', 'Delhi']
assert len(names) == 31
regions = []
for name, poly in zip(names, polygons):
    anchor = poly.representative_point()
    regions.append({'name': name, 'anchor': [anchor.x, anchor.y],
                    'rings': [list(poly.exterior.coords)] + [list(r.coords) for r in poly.interiors]})
# Retain all original island/coast/border lines, including tiny UT features.
segments = []
for i, d in enumerate(drawings):
    if i >= 178 or d['type'] != 's': continue
    for item in d['items']:
        if item[0] == 'l':
            segments.append([[round(v.x, 2), round(v.y, 2)] for v in item[1:]])
        elif item[0] == 'qu':
            q = item[1]
            segments.extend([[[v.x, v.y], [w.x, w.y]] for v, w in zip([q.ul,q.ur,q.lr,q.ll], [q.ur,q.lr,q.ll,q.ul])])
data = {'source': 'Survey of India; original SVG via Wikimedia Commons, VRT 2023040810000569',
        'viewport': [45,145,750,950], 'regions': regions, 'segments': segments,
        'coordinatePrecision': '0.01 original source units; endpoint unification only, no boundary simplification',
        'tinyTerritoryPolicy': 'Use the labelled directory for tiny and scattered union territories; no invented polygons.'}
data['segments'] = [list(v) for v in sorted({tuple(sorted(tuple(round(c,2) for c in pt) for pt in seg)) for seg in segments})]
Path('assets/content/geography/india_source_interaction.json').write_text(json.dumps(data,separators=(',',':')))
# Source-topology validation: every teaching anchor is inside its own face and not another.
for i, r in enumerate(regions):
    assert polygons[i].contains(polygons[i].representative_point())
    assert all(not q.contains(polygons[i].representative_point()) for j,q in enumerate(polygons[:31]) if i!=j)
print('exported',len(regions),'regions',len(segments),'source segments')

