#!/bin/bash

# Setup script for the Hadoop cluster
echo "Setting up Hadoop cluster..."

# Start the cluster
docker compose up -d

# Wait for services to be ready
echo "Waiting for services to start..."
sleep 30

# Check if namenode is ready
echo "Checking namenode status..."
docker exec namenode hdfs dfsadmin -report

# Create necessary directories in HDFS
echo "Creating HDFS directories..."
docker exec namenode hdfs dfs -mkdir -p /input
docker exec namenode hdfs dfs -mkdir -p /output

# Copy sample data to HDFS
echo "Copying sample data to HDFS..."
docker exec namenode hdfs dfs -put /opt/data/sample_taxi_data.csv /input/

# List files in HDFS
echo "Files in HDFS:"
docker exec namenode hdfs dfs -ls /input

echo "Cluster setup complete!"
echo "NameNode Web UI: http://localhost:9870"
echo "ResourceManager Web UI: http://localhost:8088"
echo "History Server Web UI: http://localhost:8188"