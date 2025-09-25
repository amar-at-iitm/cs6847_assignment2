#!/bin/bash

# Script to experiment with different tuning parameters
JAR_FILE="/opt/mapreduce/target/cs6847-mapreduce-1.0-SNAPSHOT.jar"
INPUT_PATH="/input/sample_taxi_data.csv"

function run_tuned_job() {
    local job_name=$1
    local driver_class=$2
    local output_path=$3
    local num_reducers=$4
    local slow_start=$5
    
    echo "Running $job_name with $num_reducers reducers and slow start threshold $slow_start..."
    
    # Clean output directory
    docker exec namenode hdfs dfs -rm -r -f $output_path
    
    # Run with custom parameters
    docker exec namenode bash -c "
        hadoop jar $JAR_FILE $driver_class $INPUT_PATH $output_path \
        -D mapreduce.job.reduces=$num_reducers \
        -D mapreduce.job.reduce.slowstart.completedmaps=$slow_start \
        -D mapreduce.map.memory.mb=512 \
        -D mapreduce.reduce.memory.mb=1024 \
        -D mapreduce.map.java.opts=-Xmx384m \
        -D mapreduce.reduce.java.opts=-Xmx768m
    "
    
    echo "Job completed with parameters: reducers=$num_reducers, slow_start=$slow_start"
    echo "----------------------------------------"
}

# Build the MapReduce JAR first
echo "Building MapReduce JAR..."
docker exec namenode bash -c "cd /opt/mapreduce && mvn clean package -q"

# Experiment with different configurations
echo "=== EXPERIMENT 1: Standard Configuration ==="
run_tuned_job "Popular Routes" "com.iitm.mapreduce.PopularRoutesDriver" "/output/popular-routes-std" 2 0.8

echo "=== EXPERIMENT 2: More Reducers ==="
run_tuned_job "Popular Routes" "com.iitm.mapreduce.PopularRoutesDriver" "/output/popular-routes-4red" 4 0.8

echo "=== EXPERIMENT 3: Early Reduce Start ==="
run_tuned_job "Popular Routes" "com.iitm.mapreduce.PopularRoutesDriver" "/output/popular-routes-early" 2 0.5

echo "=== EXPERIMENT 4: Late Reduce Start ==="
run_tuned_job "Popular Routes" "com.iitm.mapreduce.PopularRoutesDriver" "/output/popular-routes-late" 2 0.95

echo "=== EXPERIMENT 5: Single Reducer ==="
run_tuned_job "Popular Routes" "com.iitm.mapreduce.PopularRoutesDriver" "/output/popular-routes-1red" 1 0.8

echo "All tuning experiments completed!"
echo "Check job history at: http://localhost:8188"