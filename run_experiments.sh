#!/bin/bash
# run_experiments.sh — Run all MapReduce programs with varying parameters
# Usage:
#   ./run_experiments.sh       # runs for all months of the selected year
#   ./run_experiments.sh 01    # runs for a specific month

YEAR=2023
MONTH=$1                   # Optional: specify month (01, 02, ..., 12)
REDUCERS_LIST=(1 2 4 8)   # Number of reducers to experiment with
SLOW_START_LIST=(0.25 0.5 0.75)  # MapReduce slow start fractions

PROGRAMS=("popular_routes" "expensive_routes" "pickup_drop" "nightlife")
OUTPUT_CSV="experiments/execution_times.csv"

# Initialize CSV if not exist
if [ ! -f $OUTPUT_CSV ]; then
    echo "program,month,reducers,slow_start,time_sec" > $OUTPUT_CSV
fi

run_program() {
    local prog=$1
    local mon=$2
    local reducers=$3
    local slow_start=$4

    echo ">>> Running $prog for $YEAR-$mon | reducers=$reducers slow_start=$slow_start"

    start_time=$(date +%s)

    HADOOP_OPTS="-D mapreduce.job.reduces=$reducers -D mapreduce.job.reduce.slowstart.completedmaps=$slow_start"

    (cd $prog && bash run_month.sh $mon "$HADOOP_OPTS")
    status=$?

    end_time=$(date +%s)
    elapsed=$((end_time - start_time))

    if [ $status -eq 0 ]; then
        echo "$prog,$mon,$reducers,$slow_start,$elapsed" >> $OUTPUT_CSV
    else
        echo "ERROR: $prog failed for month $mon with reducers=$reducers slow_start=$slow_start"
    fi
}



months=()
if [ -n "$MONTH" ]; then
    months=($MONTH)
else
    months=(01 02 03 04 05 06 07 08 09 10 11 12)
fi

for prog in "${PROGRAMS[@]}"; do
    for mon in "${months[@]}"; do
        for red in "${REDUCERS_LIST[@]}"; do
            for ss in "${SLOW_START_LIST[@]}"; do
                run_program $prog $mon $red $ss
            done
        done
    done
done

echo ">>> All experiments completed. Results stored in $OUTPUT_CSV"
