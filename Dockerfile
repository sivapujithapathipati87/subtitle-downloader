# Use an openjdk base image
FROM tomcat:latest

# Set the working directory in the container
WORKDIR /app

# Copy the application JAR file into the container
COPY target/subtitle-downloader.jar /app/subtitle-downloader.jar

# Expose any ports the app needs
EXPOSE 8080

# Run the application
CMD ["java", "-jar", "subtitle-downloader.jar"]
