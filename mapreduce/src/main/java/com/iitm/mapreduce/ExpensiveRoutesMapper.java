package com.iitm.mapreduce;

import java.io.IOException;

import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class ExpensiveRoutesMapper extends Mapper<LongWritable, Text, Text, DoubleWritable> {
    
    private Text route = new Text();
    private DoubleWritable fare = new DoubleWritable();
    
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
            if (fields.length >= 4) {
                String pickupLocation = fields[1].trim().replaceAll("\"", "");
                String dropoffLocation = fields[2].trim().replaceAll("\"", "");
                double fareAmount = Double.parseDouble(fields[3].trim());
                
                // Create route key as "pickup -> dropoff"
                String routeKey = pickupLocation + " -> " + dropoffLocation;
                route.set(routeKey);
                fare.set(fareAmount);
                
                context.write(route, fare);
            }
        } catch (Exception e) {
            // Skip malformed lines
            System.err.println("Error processing line: " + line);
        }
    }
}