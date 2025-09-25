# Dockerfile for building MapReduce applications
FROM maven:3.6.3-openjdk-8-slim

WORKDIR /app

# Copy Maven project files
COPY mapreduce/pom.xml .
COPY mapreduce/src ./src

# Build the project
RUN mvn clean package -q

# The JAR file will be available at /app/target/cs6847-mapreduce-1.0-SNAPSHOT.jar