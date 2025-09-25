#!/bin/bash

# Validation script to check if everything is set up correctly
echo "=== CS6847 Assignment 2 Validation ==="

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed or not in PATH"
    exit 1
else
    echo "✅ Docker is available"
fi

# Check if Docker Compose is available (try both formats)
if command -v docker-compose &> /dev/null; then
    echo "✅ Docker Compose (standalone) is available"
    COMPOSE_CMD="docker-compose"
elif docker compose version &> /dev/null; then
    echo "✅ Docker Compose (plugin) is available"
    COMPOSE_CMD="docker compose"
else
    echo "❌ Docker Compose is not installed or not available"
    exit 1
fi

# Check if Maven JAR was built successfully
if [ -f "mapreduce/target/cs6847-mapreduce-1.0-SNAPSHOT.jar" ]; then
    echo "✅ MapReduce JAR built successfully"
else
    echo "❌ MapReduce JAR not found - running build..."
    cd mapreduce && mvn clean package -q
    if [ -f "target/cs6847-mapreduce-1.0-SNAPSHOT.jar" ]; then
        echo "✅ MapReduce JAR built successfully"
        cd ..
    else
        echo "❌ Failed to build MapReduce JAR"
        exit 1
    fi
fi

# Check if sample data exists
if [ -f "data/sample_taxi_data.csv" ]; then
    echo "✅ Sample dataset is available"
    echo "   Dataset contains $(wc -l < data/sample_taxi_data.csv) lines"
else
    echo "❌ Sample dataset not found"
    exit 1
fi

# Check if all required scripts exist and are executable
SCRIPTS=("setup-cluster.sh" "run-mapreduce.sh" "tune-parameters.sh" "get-top-results.sh")
for script in "${SCRIPTS[@]}"; do
    if [ -x "scripts/$script" ]; then
        echo "✅ Script $script is executable"
    else
        echo "❌ Script $script is missing or not executable"
        exit 1
    fi
done

# Validate MapReduce Java files
JAVA_FILES=(
    "PopularRoutesDriver.java"
    "ExpensiveRoutesDriver.java" 
    "PopularLocationsDriver.java"
    "NightlifeSpotsDriver.java"
)

for java_file in "${JAVA_FILES[@]}"; do
    if [ -f "mapreduce/src/main/java/com/iitm/mapreduce/$java_file" ]; then
        echo "✅ MapReduce program $java_file exists"
    else
        echo "❌ MapReduce program $java_file is missing"
        exit 1
    fi
done

echo ""
echo "🎉 All validation checks passed!"
echo ""
echo "Next steps:"
echo "1. Start the cluster: ./scripts/setup-cluster.sh"
echo "2. Run MapReduce jobs: ./scripts/run-mapreduce.sh"
echo "3. Get top results: ./scripts/get-top-results.sh"
echo "4. Experiment with tuning: ./scripts/tune-parameters.sh"
echo ""
echo "Web UIs will be available at:"
echo "- NameNode: http://localhost:9870"
echo "- ResourceManager: http://localhost:8088"
echo "- History Server: http://localhost:8188"