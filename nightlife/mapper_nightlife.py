#!/usr/bin/env python3
import sys
import csv
from datetime import datetime

for line in sys.stdin:
    try:
        fields = list(csv.reader([line]))[0]
        dt_str = fields[1].strip()  # pickup datetime
        pu = fields[7].strip()
        do = fields[8].strip()

        dt = datetime.strptime(dt_str, "%Y-%m-%d %H:%M:%S")
        hour = dt.hour
        # Nightlife = 8PM (20) to 2AM (2)
        if (hour >= 20) or (hour < 2):
            print(f"{pu},{do}\t1")
    except:
        continue
