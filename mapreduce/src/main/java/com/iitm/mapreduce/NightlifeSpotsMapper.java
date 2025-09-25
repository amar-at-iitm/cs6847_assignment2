package com.iitm.mapreduce;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.hadoop.io.IntWritable;
import org.apache.hadoop.io.LongWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Mapper;

public class NightlifeSpotsMapper extends Mapper<LongWritable, Text, Text, IntWritable> {
    
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
                String timestamp = fields[0].trim().replaceAll("\"", "");
                String dropoffLocation = fields[2].trim().replaceAll("\"", "");
                
                // Parse timestamp and check if it's between 8 PM and 2 AM
                if (isNightlifeTime(timestamp)) {
                    location.set(dropoffLocation);
                    context.write(location, one);
                }
            }
        } catch (Exception e) {
            // Skip malformed lines
            System.err.println("Error processing line: " + line);
        }
    }
    
    private boolean isNightlifeTime(String timestamp) {
        try {
            // Try different timestamp formats
            SimpleDateFormat[] formats = {
                new SimpleDateFormat("yyyy-MM-dd HH:mm:ss"),
                new SimpleDateFormat("MM/dd/yyyy HH:mm"),
                new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss"),
                new SimpleDateFormat("dd-MM-yyyy HH:mm:ss")
            };
            
            Date date = null;
            for (SimpleDateFormat format : formats) {
                try {
                    date = format.parse(timestamp);
                    break;
                } catch (Exception e) {
                    // Try next format
                }
            }
            
            if (date != null) {
                SimpleDateFormat hourFormat = new SimpleDateFormat("HH");
                int hour = Integer.parseInt(hourFormat.format(date));
                
                // Check if time is between 20:00 (8 PM) and 23:59, or between 00:00 and 02:00 (2 AM)
                return (hour >= 20 && hour <= 23) || (hour >= 0 && hour <= 2);
            }
        } catch (Exception e) {
            // Skip malformed timestamps
        }
        return false;
    }
}