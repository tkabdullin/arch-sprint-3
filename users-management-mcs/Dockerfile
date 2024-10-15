# Use an official Gradle image to build the application
FROM gradle:7.6.0-jdk17 AS build
# Set the working directory inside the container
WORKDIR /app
# Copy all project files into the container
COPY . .
# Build the application
RUN gradle build -x test --no-daemon
# Use an official OpenJDK image for running the application
FROM eclipse-temurin:17-jdk-jammy
# Set the working directory inside the container for the application
WORKDIR /app
# Copy the built jar file from the build stage
COPY --from=build /app/build/libs/*.jar /app/app.jar
# Expose the application port (change the port if necessary)
EXPOSE 8080
# Run the Spring Boot application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]