import os
from sys import argv

wikiw_d = {}
key = 'empty'
with open(os.path.dirname(__file__) + '/wikiw.txt') as archive:
    for raw_entry in archive:
        entry = raw_entry.strip()
        if entry.startswith('#') or len(entry) == 0:
            continue
        if entry.startswith(':::') and entry.endswith(':::'):
            key = entry.replace(':::', '')
        else:
            wikiw_d[key] = wikiw_d[key] + [entry] if key in wikiw_d.keys() else [entry]

if len(argv) > 1:
    query = argv[1]
    hits = [i for i in wikiw_d.keys() if query in i]
    for key in hits:
        print(f'{key}:')
        for line in wikiw_d[key]:
            print(line)
        print()
