#!/bin/bash
# run_month.sh — Run MapReduce for a specific month
# Usage: ./run_month.sh 01 "[HADOOP_OPTS]"

MONTH=$1
YEAR=2023
HADOOP_OPTS=$2               # optional Hadoop options
INPUT_PATH=/data/nyc_taxi/${YEAR}/yellow_tripdata_${YEAR}-${MONTH}.csv
TEMP_OUT=/output/popular_routes_temp_${YEAR}_${MONTH}
FINAL_OUT=/output/popular_routes_${YEAR}_${MONTH}

# Check input file
echo ">>> Checking HDFS input: $INPUT_PATH"
hdfs dfs -test -e $INPUT_PATH
if [ $? -ne 0 ]; then
    echo "ERROR: Input file not found in HDFS: $INPUT_PATH"
    exit 1
fi

# Remove old output folders
hdfs dfs -rm -r -f $TEMP_OUT $FINAL_OUT

echo ">>> Running Stage 1: Count routes"
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming*.jar \
    $HADOOP_OPTS \
    -D mapreduce.job.name="Popular Routes ${YEAR}-${MONTH} Stage1" \
    -files mapper_popular.py,reducer_sum.py \
    -mapper "python3 mapper_popular.py" \
    -reducer "python3 reducer_sum.py" \
    -input $INPUT_PATH \
    -output $TEMP_OUT

if [ $? -ne 0 ]; then
    echo "Stage 1 failed"
    exit 1
fi

echo ">>> Running Stage 2: Top 5 selection"
hadoop jar $HADOOP_HOME/share/hadoop/tools/lib/hadoop-streaming*.jar \
    $HADOOP_OPTS \
    -D mapreduce.job.name="Popular Routes ${YEAR}-${MONTH} Stage2" \
    -files mapper_passthrough.py,reducer_topn.py \
    -mapper "python3 mapper_passthrough.py" \
    -reducer "python3 reducer_topn.py 5" \
    -input $TEMP_OUT \
    -output $FINAL_OUT

if [ $? -eq 0 ]; then
    echo "Completed popular routes for ${YEAR}-${MONTH}"
    echo "Output stored at: $FINAL_OUT"
else
    echo "Stage 2 failed"
fi
