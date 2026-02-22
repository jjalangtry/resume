"""
Scans public/resumes/ for JakobLangtry{Mon}{YY}.pdf files,
sorts them newest-first, and writes versions.json.
"""
import os
import json
import re

MONTHS = {
    'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4,
    'May': 5, 'Jun': 6, 'Jul': 7, 'Aug': 8,
    'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
}

pattern = re.compile(r'^JakobLangtry([A-Z][a-z]{2})(\d{2})\.pdf$')
entries = []

for fname in sorted(os.listdir('public/resumes')):
    m = pattern.match(fname)
    if m:
        mon, yr = m.group(1), m.group(2)
        sort_key = (int(yr) + 2000) * 100 + MONTHS.get(mon, 0)
        entries.append({'filename': fname, 'label': f"{mon} '{yr}", 'sort_key': sort_key})

entries.sort(key=lambda x: x['sort_key'], reverse=True)
versions = [{'filename': e['filename'], 'label': e['label']} for e in entries]
manifest = {'latest': versions[0]['filename'] if versions else '', 'versions': versions}

with open('public/resumes/versions.json', 'w') as f:
    json.dump(manifest, f, indent=2)

print(f"versions.json updated — {len(versions)} version(s), latest: {manifest['latest']}")
