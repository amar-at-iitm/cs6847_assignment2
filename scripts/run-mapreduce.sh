#!/bin/bash

# Script to run MapReduce jobs
JAR_FILE="/opt/mapreduce/target/cs6847-mapreduce-1.0-SNAPSHOT.jar"
INPUT_PATH="/input/sample_taxi_data.csv"

function run_job() {
    local job_name=$1
    local driver_class=$2
    local output_path=$3
    
    echo "Running $job_name job..."
    
    # Clean output directory
    docker exec namenode hdfs dfs -rm -r -f $output_path
    
    # Run the MapReduce job
    docker exec namenode hadoop jar $JAR_FILE $driver_class $INPUT_PATH $output_path
    
    # Show results
    echo "Results for $job_name:"
    docker exec namenode hdfs dfs -cat $output_path/part-r-*
    echo "----------------------------------------"
}

# Build the MapReduce JAR first
echo "Building MapReduce JAR..."
docker exec namenode bash -c "cd /opt/mapreduce && mvn clean package -q"

# Run all MapReduce jobs
run_job "Popular Routes" "com.iitm.mapreduce.PopularRoutesDriver" "/output/popular-routes"
run_job "Expensive Routes" "com.iitm.mapreduce.ExpensiveRoutesDriver" "/output/expensive-routes"
run_job "Popular Locations" "com.iitm.mapreduce.PopularLocationsDriver" "/output/popular-locations"
run_job "Nightlife Spots" "com.iitm.mapreduce.NightlifeSpotsDriver" "/output/nightlife-spots"

echo "All MapReduce jobs completed!"