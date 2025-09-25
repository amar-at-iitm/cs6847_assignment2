package com.iitm.mapreduce;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class ExpensiveRoutesDriver {
    
    public static void main(String[] args) throws Exception {
        
        if (args.length != 2) {
            System.err.println("Usage: ExpensiveRoutesDriver <input path> <output path>");
            System.exit(-1);
        }
        
        Configuration conf = new Configuration();
        
        // Set tuning parameters
        conf.setInt("mapreduce.job.reduces", 2);  // Use 2 reducers for our 2-node cluster
        conf.setBoolean("mapreduce.job.ubertask.enable", false);
        conf.setFloat("mapreduce.job.reduce.slowstart.completedmaps", 0.8f);  // Slow start threshold
        
        Job job = Job.getInstance(conf, "expensive routes");
        job.setJar("cs6847-mapreduce-1.0-SNAPSHOT.jar");
        job.setMapperClass(ExpensiveRoutesMapper.class);
        job.setCombinerClass(ExpensiveRoutesReducer.class);
        job.setReducerClass(ExpensiveRoutesReducer.class);
        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(DoubleWritable.class);
        
        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));
        
        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}