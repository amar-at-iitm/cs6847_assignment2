#!/usr/bin/env python3
import sys
from heapq import nlargest

data = []
for line in sys.stdin:
    try:
        key, value = line.strip().split('\t')
        value = float(value)
        data.append((value, key))
    except:
        continue

for value, key in nlargest(5, data):
    print(f"{key}\t{value}")
