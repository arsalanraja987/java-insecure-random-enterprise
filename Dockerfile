FROM eclipse-temurin:17-jdk-jammy

# Install tcpdump to monitor outbound traffic
RUN apt-get update && \
    apt-get install -y tcpdump && \
    mkdir /app

# Copy source and entrypoint
COPY src/main/java/InsecureRandomGenerator.java /app/
COPY entrypoint.sh /app/

# Set working directory
WORKDIR /app

# Compile Java code
RUN javac InsecureRandomGenerator.java

# Set entrypoint
ENTRYPOINT ["sh", "entrypoint.sh"]
