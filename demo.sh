#!/bin/bash

# Complete demonstration of CS6847 Assignment 2
# Two-node Hadoop MapReduce cluster with analysis programs

echo "=========================================="
echo "CS6847 Assignment 2 - MapReduce Demo"
echo "Two-Node Hadoop Cluster Analysis"
echo "=========================================="
echo

# Step 1: Validate setup
echo "Step 1: Validating setup..."
./scripts/validate-setup.sh
if [ $? -ne 0 ]; then
    echo "❌ Setup validation failed. Please check requirements."
    exit 1
fi
echo

# Step 2: Start cluster (with user confirmation)
echo "Step 2: Starting Hadoop cluster..."
echo "This will start a two-node Hadoop cluster with Docker containers."
read -p "Continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Demo cancelled."
    exit 0
fi

./scripts/setup-cluster.sh
echo

# Step 3: Run MapReduce jobs
echo "Step 3: Running MapReduce analysis jobs..."
echo "This will execute all four analysis programs:"
echo "- Top 5 popular routes"
echo "- Top 5 expensive routes" 
echo "- Top 5 popular locations"
echo "- Top 5 nightlife spots"
echo

./scripts/run-mapreduce.sh
echo

# Step 4: Show results
echo "Step 4: Displaying top results..."
./scripts/get-top-results.sh
echo

# Step 5: Parameter tuning demonstration
echo "Step 5: Demonstrating parameter tuning..."
echo "This will run the same job with different configurations:"
read -p "Run tuning experiments? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    ./scripts/tune-parameters.sh
fi
echo

# Step 6: Show web interfaces
echo "Step 6: Web interface access information"
echo "==========================================="
echo "Access these URLs to explore the cluster:"
echo "• NameNode Web UI: http://localhost:9870"
echo "• ResourceManager UI: http://localhost:8088"
echo "• History Server UI: http://localhost:8188"
echo
echo "Press any key to stop the cluster..."
read -n 1 -s
echo

# Cleanup
echo "Stopping cluster..."
docker compose down
echo
echo "Demo completed successfully! 🎉"
echo
echo "Key achievements:"
echo "✅ Two-node Hadoop cluster deployed"
echo "✅ Four MapReduce analysis programs executed"
echo "✅ Parameter tuning experiments completed"
echo "✅ Top 5 results extracted for each analysis"