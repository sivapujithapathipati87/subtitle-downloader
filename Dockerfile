# Use an openjdk base image
FROM tomcat:latest

# Set the working directory in the container
WORKDIR /app

# Copy the application JAR file into the container
COPY . /app/subtitle-downloader.jar

# Expose any ports the app needs
EXPOSE 8000

# Run the application
CMD ["java", "-jar", "subtitle-downloader.jar"]
