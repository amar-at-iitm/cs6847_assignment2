package com.iitm.mapreduce;

import java.io.IOException;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class PopularLocationsMapper extends Mapper<LongWritable, Text, Text, IntWritable> {
    
    private final static IntWritable one = new IntWritable(1);
    private Text location = new Text();
    
    @Override
    public void map(LongWritable key, Text value, Context context) 
            throws IOException, InterruptedException {
        
        // Skip header line
        if (key.get() == 0) {
            return;
        }
        
        String line = value.toString();
        String[] fields = line.split(",");
        
        try {
            // Assuming CSV format: timestamp,pickup_location,dropoff_location,fare,distance,...
            if (fields.length >= 3) {
                String pickupLocation = fields[1].trim().replaceAll("\"", "");
                String dropoffLocation = fields[2].trim().replaceAll("\"", "");
                
                // Count both pickup and dropoff locations
                location.set("PICKUP:" + pickupLocation);
                context.write(location, one);
                
                location.set("DROPOFF:" + dropoffLocation);
                context.write(location, one);
            }
        } catch (Exception e) {
            // Skip malformed lines
            System.err.println("Error processing line: " + line);
        }
    }
}