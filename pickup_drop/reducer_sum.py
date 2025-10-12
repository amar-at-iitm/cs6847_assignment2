#!/usr/bin/env python3
import sys

current_key = None
count = 0

for line in sys.stdin:
    key, value = line.strip().split('\t')
    value = int(value)

    if key == current_key:
        count += value
    else:
        if current_key:
            print(f"{current_key}\t{count}")
        current_key = key
        count = value

if current_key:
    print(f"{current_key}\t{count}")
