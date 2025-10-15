#!/usr/bin/env python3
import sys

current_key = None
total_sum = 0
count = 0

for line in sys.stdin:
    key, value = line.strip().split('\t')
    value = float(value)

    if key == current_key:
        total_sum += value
        count += 1
    else:
        if current_key:
            avg = total_sum / count if count else 0
            print(f"{current_key}\t{avg}")
        current_key = key
        total_sum = value
        count = 1

if current_key:
    avg = total_sum / count if count else 0
    print(f"{current_key}\t{avg}")
