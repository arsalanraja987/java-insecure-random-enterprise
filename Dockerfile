# Use official OpenJDK base image
FROM eclipse-temurin:17-jdk-jammy

# Set working directory
WORKDIR /app

# Copy entire Java source directory into image
COPY ./src /app/src

# Compile Java files
RUN javac /app/src/main/java/*.java

# Run the secure version by default
CMD ["java", "-cp", "/app/src/main/java", "SecureTokenGenerator"]
