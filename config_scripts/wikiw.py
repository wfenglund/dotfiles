import os
from sys import argv

wikiw_d = {}
key = 'empty'
with open(argv[1]) as archive: # open first arg as archive
    for raw_entry in archive:
        entry = raw_entry.strip()
        if entry.startswith('#') or len(entry) == 0: # if a comment
            continue
        if entry.startswith(':::') and entry.endswith(':::'): # if a wikiw key
            key = entry.replace(':::', '')
        else: # if wikiw value
            wikiw_d[key] = wikiw_d[key] + [entry] if key in wikiw_d.keys() else [entry]

if len(argv) > 2: # if any search terms are given
    query = argv[2:] # grab all search terms
    hits = [i for i in wikiw_d.keys() if all(j in i for j in query)] # grab all hits that contain all search terms
    for key in hits: # print all entries found
        print(f'{key}:')
        for line in wikiw_d[key]:
            print(line)
        print()
