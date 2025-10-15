#!/usr/bin/env python3
import sys
import csv

for line in sys.stdin:
    try:
        fields = list(csv.reader([line]))[0]
        pu = fields[7].strip()
        do = fields[8].strip()
        total = float(fields[16].strip())   # total_amount
        if pu and do:
            print(f"{pu},{do}\t{total}")
    except:
        continue
