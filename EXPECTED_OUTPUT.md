# Expected Output Examples

This document shows the expected output format from each MapReduce analysis program.

## 1. Top 5 Most Popular Routes

```
=== TOP 5 POPULAR ROUTES ===
Downtown -> Airport    3
Airport -> Hotel District    3
Hotel District -> Entertainment Quarter    3
Entertainment Quarter -> Bar Street    2
Bar Street -> Club District    2
```

## 2. Top 5 Most Expensive Routes

```
=== TOP 5 EXPENSIVE ROUTES ===
Business District -> Airport    52.0
Downtown -> Airport    45.5
Airport -> Bar Street    42.0
Airport -> Hotel District    35.75
Hotel District -> Downtown    31.25
```

## 3. Top 5 Most Popular Locations

```
=== TOP 5 POPULAR LOCATIONS ===
PICKUP:Downtown    8
DROPOFF:Airport    6
PICKUP:Airport    5
DROPOFF:Hotel District    5
PICKUP:Hotel District    4
```

## 4. Top 5 Most Popular Nightlife Spots

```
=== TOP 5 NIGHTLIFE SPOTS ===
Club District    4
Late Night Diner    4
Entertainment Quarter    3
Residential Area    2
Bar Street    2
```

## Parameter Tuning Results

When running with different configurations, you'll see timing differences:

```
=== EXPERIMENT 1: Standard Configuration ===
Job completed with parameters: reducers=2, slow_start=0.8
Job execution time: ~30-45 seconds

=== EXPERIMENT 2: More Reducers ===
Job completed with parameters: reducers=4, slow_start=0.8
Job execution time: ~25-35 seconds (faster due to more parallelism)

=== EXPERIMENT 3: Early Reduce Start ===
Job completed with parameters: reducers=2, slow_start=0.5
Job execution time: ~35-50 seconds (may be slower due to early reduce start)
```

## Web Interface Screenshots

### NameNode UI (http://localhost:9870)
- Shows cluster overview and HDFS status
- Displays DataNode health
- File system browser

### ResourceManager UI (http://localhost:8088)  
- Active applications and job status
- Cluster metrics and resource utilization
- Node manager information

### History Server UI (http://localhost:8188)
- Completed job history
- Job execution details and timing
- Map/Reduce task performance metrics

## Performance Considerations

The sample dataset contains 50 records, so actual production datasets would show:
1. **More pronounced differences** between tuning parameters
2. **Longer execution times** requiring more careful optimization
3. **More diverse results** in the top 5 lists
4. **Better utilization** of the distributed cluster capabilities

For production use:
- Increase dataset size to see meaningful performance differences
- Adjust memory settings based on data volume
- Tune number of reducers based on output data size
- Monitor resource utilization through web interfaces