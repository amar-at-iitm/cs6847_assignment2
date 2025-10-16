#!/usr/bin/env python3
"""
collect_outputs.py
Download HDFS outputs for all programs and months for a given year.
Organize locally for further analysis and plotting.
"""

import os
import subprocess
import argparse
from zone_mapper import id_to_name

# Programs and their HDFS output prefixes
PROGRAMS = {
    "popular_routes": "/output/popular_routes_{}_{:02d}",
    "expensive_routes": "/output/expensive_routes_{}_{:02d}",
    "pickup_drop": "/output/pickdrop_{}_{:02d}",
    "nightlife": "/output/nightlife_{}_{:02d}"
}

LOCAL_BASE = "./collected_outputs"

def run_cmd(cmd):
    """Run shell command and raise error if fails"""
    print(f"Running: {cmd}")
    result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Command failed:\n{result.stderr}")
        raise RuntimeError(f"Command failed: {cmd}")
    return result.stdout.strip()

def download_program_outputs(program, year):
    """Download all 12 months for a program"""
    local_dir = os.path.join(LOCAL_BASE, program, str(year))
    os.makedirs(local_dir, exist_ok=True)

    for month in range(1, 13):
        hdfs_path = PROGRAMS[program].format(year, month)
        output_file = os.path.join(local_dir, f"{month:02d}.txt")

        # Check if HDFS path exists
        check_cmd = f"hdfs dfs -test -e {hdfs_path}"
        if subprocess.run(check_cmd, shell=True).returncode != 0:
            print(f"Warning: HDFS path not found: {hdfs_path}")
            continue

        # Fetch part-00000 and map IDs to names if needed
        part_file = os.path.join(hdfs_path, "part-00000")
        content = run_cmd(f"hdfs dfs -cat {part_file}")

        # Map IDs to names (only for programs that use location IDs)
        if program in ["popular_routes", "pickup_drop", "nightlife", "expensive_routes"]:
            mapped_lines = []
            for line in content.splitlines():
                parts = line.strip().split()
                if len(parts) < 2:
                    continue
                key, value = parts[0], parts[1]
                # For routes, key may be "237,236"
                if "," in key:
                    ids = key.split(",")
                    names = [id_to_name(i) for i in ids]
                    key_name = ",".join(names)
                else:
                    key_name = id_to_name(key)
                mapped_lines.append(f"{key_name}\t{value}")
            content = "\n".join(mapped_lines)

        with open(output_file, "w") as f:
            f.write(content)
        print(f"Saved {output_file}")


def main():
    parser = argparse.ArgumentParser(description="Collect HDFS outputs locally")
    parser.add_argument("--year", type=int, default=2023, help="Year to collect outputs for")
    parser.add_argument("--programs", nargs="*", default=list(PROGRAMS.keys()),
                        help="Programs to collect (default: all)")
    args = parser.parse_args()

    for program in args.programs:
        if program not in PROGRAMS:
            print(f"Unknown program: {program}, skipping.")
            continue
        download_program_outputs(program, args.year)

if __name__ == "__main__":
    main()
