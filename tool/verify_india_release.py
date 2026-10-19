import hashlib
import json
from pathlib import Path
from zipfile import ZipFile

apk = Path('release-output/sproutlab-0.1.7+9-india-learning-release.apk')
manifest = json.loads(Path('assets/content/explorer_asset_provenance.json').read_text(encoding='utf-8-sig'))
checks = []
with ZipFile(apk) as archive:
    assert archive.testzip() is None
    for item in manifest['files']:
        source = Path(item['path']).read_bytes()
        bundled = archive.read('assets/flutter_assets/' + item['path'])
        assert source == bundled, item['path']
        assert hashlib.sha256(bundled).hexdigest() == item['sha256'], item['path']
        checks.append({'path': item['path'], 'bytes': len(bundled), 'sha256': item['sha256']})
    for path in ['assets/audio/music.wav', 'assets/content/audio_provenance.json', 'assets/content/explorer_asset_provenance.json']:
        assert archive.read('assets/flutter_assets/' + path) == Path(path).read_bytes(), path
    geometry = json.loads(archive.read('assets/flutter_assets/assets/content/geography/india_source_interaction.json'))
    assert len(geometry['regions']) == 31
result = {'apk': apk.name, 'bytes': apk.stat().st_size, 'sha256': hashlib.sha256(apk.read_bytes()).hexdigest(), 'archiveIntegrity': True, 'sourceMapRegions': 31, 'bundledMedia': checks}
Path('release-output/sproutlab-0.1.7+9-verification.json').write_text(json.dumps(result, indent=2))
print(json.dumps({k:v for k,v in result.items() if k != 'bundledMedia'}))
print('Verified',len(checks),'media/geometry assets plus music and provenance byte-for-byte')
