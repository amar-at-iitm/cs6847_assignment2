# cs6847_assignment2: Hadoop MapReduce – NYC Taxi Dataset

### Overview

This assignment analyzes the **New York City Taxi Dataset** using **Hadoop MapReduce** to extract insights on travel patterns, popular routes, and expensive trips.

The project runs on a **two-node Hadoop cluster (master + slave)** and performs four main analyses:

1. **Popular Routes** – Top 5 most frequently traveled routes
2. **Expensive Routes** – Top 5 routes with the highest average fare
3. **Pickup & Drop Locations** – Top 5 most visited pickup/dropoff zones
4. **Nightlife Spots** – Top 5 busiest routes between 8 PM and 2 AM

## Project Structure
```
cs6847_assignment2/
├── popular_routes/
│   ├── mapper_popular.py
│   ├── reducer_sum.py
│   ├── mapper_passthrough.py
│   ├── reducer_topn.py
│   └── run_month.sh
│
├── expensive_routes/
│   ├── mapper_expensive.py
│   ├── reducer_sum_and_count.py
│   ├── mapper_passthrough.py
│   ├── reducer_topn.py
│   └── run_month.sh
│
├── pickup_drop/
│   ├── mapper_pickdrop.py
│   ├── reducer_sum.py
│   ├── mapper_passthrough.py
│   ├── reducer_topn.py
│   └── run_month.sh
│
├── nightlife/
│   ├── mapper_nightlife.py
│   ├── reducer_sum.py
│   ├── mapper_passthrough.py
│   ├── reducer_topn.py
│   └── run_month.sh
│
├── experiments/
│ ├── taxi+_zone_lookup.csv             # contains zone id and their name
│ ├── execution_times.csv               # Contains execution time, reducers, slowstart 
│ ├── collect_ouputs.py                 # download hdfs output to local in desired way 
│ ├── zone_mapper.py                    # location id to zone name 
│ ├── plot_experiments.py               # plot the results
│ └── collected_outputs/                # contains outputs in human readable form
│
├── plots/                              # contains all the plots
|
├── run_experiments.sh                  # run all the experiments 
├── start-hadoop                         
├── stop-hadoop                         
├── README.md
└── report.pdf                          # Includes  analysis and plots
```






### Hadoop Cluster Setup

* 2-node cluster (1 master, 1 slave)
* HDFS directories:

  * `/data/nyc_taxi/2023/yellow_tripdata_2023-XX.csv`
  * `/output/<job_name>_2023_XX/`
* YARN ResourceManager: `http://master:8088/cluster`
* NodeManager (each node): `http://slave:8042/node`

Ensure all nodes are accessible by hostname and configured in `/etc/hosts`.
If ip address of master or any slave is changed, then it must be updated at `nano /etc/hosts`.

**Example:**
```
192.168.1.107   master
192.168.1.108   slave
```

From Root of the project:
``` bash
./start-hadoop             # To start the hadoop setup

jps                        # Process Status

./stop-hadoop             # To stop the hadoop setup
```
If nodemanager doesn't starts automatically, then start it using 
```bash
yarn-daemon.sh start nodemanager
```



### Running the Programs

Each program can be run **month-wise** using its `run_month.sh` script:
* 01-January, 02-February, 03-March, ....., 12-December

```bash
cd popular_routes/
./run_month.sh 01       # For January
```
**View Results**
```bash
hdfs dfs -cat /output/popular_routes_2023_01/part-00000
```

Similarly:

```bash
cd expensive_routes/
./run_month.sh 02
cd ../pickup_drop/
./run_month.sh 02
cd ../nightlife/
./run_month.sh 02
```

Each script:

* Reads input from `/data/nyc_taxi/2023/yellow_tripdata_2023-MM.csv`
* Writes output to `/output/<job_name>_2023_MM/`
* Performs two MapReduce stages (main + Top-N reduction)


### Running All Experiments Automatically

To execute **all programs for all months** and generate experimental results:

```bash
./run_experiments.sh
```
**OR**
```bash
./run_experiments.sh 01         # For January all four experiments with reducer and slow_start
```

This script:

1. Runs all MapReduce programs for every month (Jan–Dec)
2. Varies parameters:

   * **Number of reducers**
   * **MapReduce slow start parameter**
3. Collects execution times and results
4. Calls `experiments/plot_experiments.py` to generate plots

---

### Cleaning Outputs (Before Rerun)

To avoid conflicts when rerunning:

```bash
python3 experiments/clean_outputs.py
```

This removes:

* Old HDFS `/output/...` folders
* Local experiment results in `experiments/collected_outputs/`

---

### Collecting and Naming Outputs

After the MapReduce jobs finish:

```bash
python3 experiments/collect_outputs.py
```

* Downloads monthly HDFS outputs to local directories
* Converts Location IDs → Zone Names using `zone_mapper.py`
* Creates structured files:

  ```
  experiments/collected_outputs/popular_routes/
  experiments/collected_outputs/expensive_routes/
  ...
  ```

Each folder will contain **12 .txt files (one per month)**, as required.

---

### Generating Plots

To visualize performance and tuning results:

```bash
python3 experiments/plot_experiments.py
```

Generates:
    1. Execution Time vs. Number of Reducers
    2. Execution Time vs. Slow Start Fraction

* All plots are saved inside the `plots/` directory.
* These plots demonstrate the effect of tuning parameters on overall job performance.



### References

* [Apache Hadoop Documentation](https://hadoop.apache.org/docs/)
* [NYC Taxi Dataset on Kaggle](https://www.kaggle.com/datasets/nyctaxi/yellow-taxi-trip-data)
* Hadoop Streaming API examples from official tutorials
