#!/usr/bin/env python3
"""
clean_outputs.py
----------------
Deletes old MapReduce output directories from HDFS and cleans local
collected results to prevent conflicts before rerunning experiments.
"""

import subprocess
import shutil
import os

# Base HDFS output directory
OUTPUT_BASE = "/output"

# List of subdirectories for different jobs
JOB_NAMES = [
    "popular_routes",
    "expensive_routes",
    "pickdrop",
    "nightlife"
]

# Year to clean
YEAR = "2023"

# Local results directory (where collect_outputs.py saves data)
LOCAL_RESULTS_DIR = os.path.join("experiments", "results")

def run_cmd(cmd):
    """Run a shell command and return its output."""
    try:
        result = subprocess.run(cmd, shell=True, check=True,
                                stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        return result.stdout.strip()
    except subprocess.CalledProcessError as e:
        print(f"[WARN] Command failed (likely folder missing): {cmd}")
        return e.stderr.strip()

def clean_hdfs_outputs():
    """Delete all output directories for the given year and jobs."""
    print(f"Cleaning old outputs from HDFS for year {YEAR}...\n")
    
    for job in JOB_NAMES:
        pattern = f"{OUTPUT_BASE}/{job}_{YEAR}_*"
        cmd = f"hdfs dfs -rm -r -f {pattern}"
        print(f"Deleting {pattern} ...")
        output = run_cmd(cmd)
        if output:
            print(output)
    print("HDFS cleanup complete!\n")

def clean_local_results():
    """Delete local results directory if exists."""
    if os.path.exists(LOCAL_RESULTS_DIR):
        print(f"Removing local results directory: {LOCAL_RESULTS_DIR}")
        shutil.rmtree(LOCAL_RESULTS_DIR)
        print("Local results cleanup complete!\n")
    else:
        print(f"[INFO] Local results directory not found: {LOCAL_RESULTS_DIR}")

def main():
    clean_hdfs_outputs()
    clean_local_results()
    print("All cleanup operations completed successfully!\n")

if __name__ == "__main__":
    main()
