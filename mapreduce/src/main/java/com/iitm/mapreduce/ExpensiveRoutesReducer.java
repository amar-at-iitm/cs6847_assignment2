package com.iitm.mapreduce;

import java.io.IOException;

import org.apache.hadoop.io.DoubleWritable;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Reducer;

public class ExpensiveRoutesReducer extends Reducer<Text, DoubleWritable, Text, DoubleWritable> {
    
    private DoubleWritable result = new DoubleWritable();
    
    @Override
    public void reduce(Text key, Iterable<DoubleWritable> values, Context context)
            throws IOException, InterruptedException {
        
        double maxFare = 0.0;
        int count = 0;
        double totalFare = 0.0;
        
        for (DoubleWritable value : values) {
            double currentFare = value.get();
            totalFare += currentFare;
            count++;
            if (currentFare > maxFare) {
                maxFare = currentFare;
            }
        }
        
        // Output average fare for the route (could also use max fare)
        double avgFare = totalFare / count;
        result.set(avgFare);
        context.write(key, result);
    }
}