# CS6847 Assignment 2 - MapReduce Cluster Analysis

This repository contains the solution to Assignment 2 of the Cloud Computing (CS6847) course. The project implements a two-node Hadoop cluster using Docker and provides MapReduce programs to analyze transportation/taxi data.

## Project Structure

```
├── docker-compose.yml          # Docker compose for 2-node Hadoop cluster
├── hadoop.env                  # Hadoop configuration environment
├── mapreduce/                  # MapReduce Java programs
│   ├── pom.xml                # Maven configuration
│   └── src/main/java/com/iitm/mapreduce/
│       ├── PopularRoutesDriver.java    # Top 5 popular routes
│       ├── ExpensiveRoutesDriver.java  # Top 5 expensive routes
│       ├── PopularLocationsDriver.java # Top 5 popular locations
│       └── NightlifeSpotsDriver.java   # Top 5 nightlife spots
├── data/
│   └── sample_taxi_data.csv    # Sample dataset for testing
└── scripts/
    ├── setup-cluster.sh        # Cluster setup script
    ├── run-mapreduce.sh        # Run all MapReduce jobs
    ├── tune-parameters.sh      # Experiment with tuning parameters
    └── get-top-results.sh      # Extract top 5 results
```

## Features

### MapReduce Programs
1. **Popular Routes Analysis** - Finds the top 5 most popular routes (pickup → dropoff combinations)
2. **Expensive Routes Analysis** - Identifies the top 5 most expensive routes by average fare
3. **Popular Locations Analysis** - Discovers the top 5 most visited pickup and dropoff locations
4. **Nightlife Spots Analysis** - Identifies the top 5 most popular nightlife destinations (8 PM - 2 AM)

### Cluster Configuration
- **Two-node setup**: 1 NameNode + 2 DataNodes with ResourceManager and NodeManagers
- **Configurable parameters**: Number of reducers, slow start threshold, memory settings
- **Web UIs**: NameNode (port 9870), ResourceManager (port 8088), History Server (port 8188)

## Quick Start

### Prerequisites
- Docker and Docker Compose installed
- At least 4GB RAM available for containers

### 1. Setup the Cluster
```bash
./scripts/setup-cluster.sh
```

### 2. Run MapReduce Jobs
```bash
./scripts/run-mapreduce.sh
```

### 3. Get Top 5 Results
```bash
./scripts/get-top-results.sh
```

### 4. Experiment with Tuning Parameters
```bash
./scripts/tune-parameters.sh
```

## Tuning Parameters Experiments

The project includes experiments with various MapReduce tuning parameters:

- **Number of Reducers**: 1, 2, 4 reducers
- **Slow Start Threshold**: 0.5, 0.8, 0.95 (controls when reduce tasks start)
- **Memory Settings**: Configurable map and reduce memory allocation
- **Compression**: Enabled for intermediate data

## Dataset Format

The expected CSV format for input data:
```
timestamp,pickup_location,dropoff_location,fare,distance
2013-01-01 08:30:00,Downtown,Airport,45.50,15.2
```

## Web Interfaces

After starting the cluster, access these URLs:
- **NameNode UI**: http://localhost:9870
- **ResourceManager UI**: http://localhost:8088  
- **History Server UI**: http://localhost:8188

## Cluster Management

### Start Cluster
```bash
docker compose up -d
```

### Stop Cluster
```bash
docker compose down
```

### View Logs
```bash
docker compose logs -f [service_name]
```

### Access Container
```bash
docker exec -it namenode bash
```

## Architecture

The cluster consists of:
- **NameNode**: HDFS metadata management
- **DataNode1 & DataNode2**: Data storage nodes
- **ResourceManager**: YARN resource management
- **NodeManager1 & NodeManager2**: Task execution nodes
- **HistoryServer**: Job history tracking

This setup provides a realistic distributed environment for MapReduce job execution and performance analysis.
