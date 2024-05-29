import os
from sys import argv

wikiw_dict = {}
with open(os.path.dirname(__file__) + '/wikiw.txt') as archive:
    for entry in archive:
        if entry.startswith('#'):
            continue
        entry_list = entry.strip().split(':::')
        wikiw_dict[entry_list[0]] = entry_list[1]

if len(argv) > 1:
    query = argv[1]
    if query in wikiw_dict.keys():
        print(wikiw_dict[query])
