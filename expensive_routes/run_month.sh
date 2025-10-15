#!/bin/bash
# run_month.sh — Run MapReduce for a specific month (Expensive Routes)
# Usage: ./run_month.sh 01 "[HADOOP_OPTS]"

MONTH=$1
YEAR=2023
HADOOP_OPTS=$2
INPUT_PATH=/data/nyc_taxi/${YEAR}/yellow_tripdata_${YEAR}-${MONTH}.csv
TEMP_OUT=/output/expensive_routes_temp_${YEAR}_${MONTH}
FINAL_OUT=/output/expensive_routes_${YEAR}_${MONTH}

echo ">>> Checking HDFS input: $INPUT_PATH"
hdfs dfs -test -e $INPUT_PATH || { echo "ERROR: Input file not found"; exit 1; }

hdfs dfs -rm -r -f $TEMP_OUT $FINAL_OUT

echo ">>> Stage 1: Sum & Count"
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming*.jar \
    $HADOOP_OPTS \
    -D mapreduce.job.name="Expensive Routes ${YEAR}-${MONTH} Stage1" \
    -files mapper_expensive.py,reducer_sum_and_count.py \
    -mapper "python3 mapper_expensive.py" \
    -reducer "python3 reducer_sum_and_count.py" \
    -input $INPUT_PATH \
    -output $TEMP_OUT

[ $? -ne 0 ] && { echo "Stage 1 failed"; exit 1; }

echo ">>> Stage 2: Top 5 expensive"
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming*.jar \
    $HADOOP_OPTS \
    -D mapreduce.job.name="Expensive Routes ${YEAR}-${MONTH} Stage2" \
    -files mapper_passthrough.py,reducer_topn.py \
    -mapper "python3 mapper_passthrough.py" \
    -reducer "python3 reducer_topn.py 5" \
    -input $TEMP_OUT \
    -output $FINAL_OUT

[ $? -eq 0 ] && echo "Completed expensive routes for ${YEAR}-${MONTH}" || echo "Stage 2 failed"
