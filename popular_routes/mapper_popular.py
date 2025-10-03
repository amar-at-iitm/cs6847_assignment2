#!/usr/bin/env python3
import sys
import csv

for line in sys.stdin:
    try:
        fields = list(csv.reader([line]))[0]
        pu = fields[7].strip()    # PULocationID
        do = fields[8].strip()    # DOLocationID
        if pu and do:
            print(f"{pu},{do}\t1")
    except:
        continue
