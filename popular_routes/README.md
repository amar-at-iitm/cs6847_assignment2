# Popular Routes Analysis (2023)

**Objective:**  
Identify the **Top 5 most popular taxi routes** (pickup → dropoff) in the NYC Taxi dataset for the year **2023**, based on the total number of trips between locations.

**Input Dataset:**  
`/data/nyc_taxi/2023/yellow_tripdata_2023-MM.csv`

**Output Directory:**  
`/output/popular_routes_2023_MM/`

## **How to Run:**  
**Make all the files executable**
```bash
chmod +x *.py
chmod +x run_month.sh
```

**Run**
* 01-January, 02-February, 03-March, ....., 12-December
 
```bash
./run_month.sh MM
```

**Example**
```bash
./run_month.sh 03
```

**View Results**
```bash
hdfs dfs -cat /output/popular_routes_2023_01/part-00000
```