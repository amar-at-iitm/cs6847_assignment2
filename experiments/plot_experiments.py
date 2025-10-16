#!/usr/bin/env python3
"""
plot_experiments.py
Read collected outputs and execution times, generate plots
for varying number of reducers and slow-start parameters.
"""

import os
import pandas as pd
import matplotlib.pyplot as plt
import argparse
import glob

COLLECTED_DIR = "./collected_outputs"
TIMES_CSV = "execution_times.csv"  # CSV with columns: program, month, reducers, slow_start, time_sec
OUTPUT_DIR = "../plots"
os.makedirs(OUTPUT_DIR, exist_ok=True)

def plot_reducers_vs_time(df, program):
    """Plot execution time vs number of reducers for a program"""
    plt.figure(figsize=(8,6))
    for month in df['month'].unique():
        month_df = df[(df['program']==program) & (df['month']==month)]
        plt.plot(month_df['reducers'], month_df['time_sec'], marker='o', label=f"Month {month:02d}")
    plt.xlabel("Number of Reducers")
    plt.ylabel("Execution Time (s)")
    plt.title(f"{program}: Execution Time vs Number of Reducers")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.savefig(f"{OUTPUT_DIR}/{program}_reducers_vs_time.png")
    plt.close()
    print(f"Saved plot: {OUTPUT_DIR}/{program}_reducers_vs_time.png")

def plot_slowstart_vs_time(df, program):
    """Plot execution time vs slow-start parameter for a program"""
    plt.figure(figsize=(8,6))
    for month in df['month'].unique():
        month_df = df[(df['program']==program) & (df['month']==month)]
        plt.plot(month_df['slow_start'], month_df['time_sec'], marker='o', label=f"Month {month:02d}")
    plt.xlabel("MapReduce Slow Start (%)")
    plt.ylabel("Execution Time (s)")
    plt.title(f"{program}: Execution Time vs Slow Start")
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.savefig(f"{OUTPUT_DIR}/{program}_slowstart_vs_time.png")
    plt.close()
    print(f"Saved plot: {OUTPUT_DIR}/{program}_slowstart_vs_time.png")

def main():
    parser = argparse.ArgumentParser(description="Plot MapReduce experiment results")
    parser.add_argument("--csv", type=str, default=TIMES_CSV, help="CSV file with execution times")
    parser.add_argument("--programs", nargs="*", default=None, help="Programs to plot (default: all in CSV)")
    args = parser.parse_args()

    if not os.path.exists(args.csv):
        raise FileNotFoundError(f"Execution times CSV not found: {args.csv}")

    df = pd.read_csv(args.csv)

    programs = args.programs if args.programs else df['program'].unique()

    for program in programs:
        plot_reducers_vs_time(df, program)
        plot_slowstart_vs_time(df, program)

if __name__ == "__main__":
    main()
