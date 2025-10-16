#!/usr/bin/env python3
"""
zone_mapper.py
Read taxi_zone_lookup.csv and provide function to map zone ID to zone name.
"""

import csv
import os

ZONE_CSV = "taxi+_zone_lookup.csv"  # LocationID -> Zone mapping
_zone_mapping = {}

def load_zones():
    """Load zone mappings from CSV"""
    global _zone_mapping
    if _zone_mapping:
        return  # Already loaded
    if not os.path.exists(ZONE_CSV):
        raise FileNotFoundError(f"Zone CSV file not found: {ZONE_CSV}")
    with open(ZONE_CSV, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            _zone_mapping[row["LocationID"]] = row["Zone"]

def id_to_name(zone_id):
    """Return zone name for given zone ID"""
    load_zones()
    return _zone_mapping.get(str(zone_id), f"Unknown({zone_id})")
