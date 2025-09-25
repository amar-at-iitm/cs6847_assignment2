#!/bin/bash

# Script to get top 5 results from each MapReduce job
function get_top_results() {
    local job_name=$1
    local output_path=$2
    
    echo "=== TOP 5 $job_name ==="
    docker exec namenode bash -c "
        hdfs dfs -cat $output_path/part-r-* | sort -k2 -nr | head -5
    "
    echo ""
}

# Get top results for all jobs
get_top_results "POPULAR ROUTES" "/output/popular-routes"
get_top_results "EXPENSIVE ROUTES" "/output/expensive-routes"
get_top_results "POPULAR LOCATIONS" "/output/popular-locations"
get_top_results "NIGHTLIFE SPOTS" "/output/nightlife-spots"