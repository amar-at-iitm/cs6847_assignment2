#!/usr/bin/env python3
import sys
import csv

for line in sys.stdin:
    try:
        fields = list(csv.reader([line]))[0]
        pu = fields[7].strip()
        do = fields[8].strip()
        if pu:
            print(f"{pu}\t1")
        if do:
            print(f"{do}\t1")
    except:
        continue
