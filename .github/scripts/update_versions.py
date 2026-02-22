"""
Scans public/resumes/ for versioned PDFs and writes versions.json.

Naming conventions handled:
  JakobLangtryFeb26.pdf          → primary version for Feb 2026
  JakobLangtryFeb26-rev1.pdf     → older revision within the same month
"""
import os
import json
import re

MONTHS = {
    'Jan': 1, 'Feb': 2, 'Mar': 3, 'Apr': 4,
    'May': 5, 'Jun': 6, 'Jul': 7, 'Aug': 8,
    'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dec': 12,
}

# Matches both "JakobLangtryFeb26.pdf" and "JakobLangtryFeb26-rev3.pdf"
pattern = re.compile(r'^JakobLangtry([A-Z][a-z]{2})(\d{2})(-rev(\d+))?\.pdf$')

entries = []
for fname in sorted(os.listdir('public/resumes')):
    m = pattern.match(fname)
    if not m:
        continue
    mon, yr, _, rev_str = m.group(1), m.group(2), m.group(3), m.group(4)
    rev = int(rev_str) if rev_str else None
    month_num = MONTHS.get(mon, 0)
    # Primary (no rev) sorts after all revs of the same month — it's the newest
    rev_sort = rev if rev is not None else 9999
    sort_key = (int(yr) + 2000) * 10000 + month_num * 100 + rev_sort

    if rev is None:
        label = f"{mon} '{yr}"
    else:
        label = f"{mon} '{yr} rev {rev}"

    entries.append({'filename': fname, 'label': label, 'sort_key': sort_key})

# Newest first: highest sort_key first
entries.sort(key=lambda x: x['sort_key'], reverse=True)
versions = [{'filename': e['filename'], 'label': e['label']} for e in entries]

# Latest is the first primary (no -rev) entry
latest = next(
    (v['filename'] for v in versions if '-rev' not in v['filename']),
    versions[0]['filename'] if versions else ''
)

manifest = {'latest': latest, 'versions': versions}

with open('public/resumes/versions.json', 'w') as f:
    json.dump(manifest, f, indent=2)

print(f"versions.json updated — {len(versions)} version(s), latest: {latest}")
