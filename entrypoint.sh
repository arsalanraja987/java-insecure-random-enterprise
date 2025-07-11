#!/bin/bash

# Create output directory for PCAP if it doesn't exist
mkdir -p /output

# Start tcpdump in background to monitor all outbound traffic
tcpdump -i any -w /output/traffic.pcap &

# Save tcpdump PID so we can kill it later
TCPDUMP_PID=$!

# Wait briefly to ensure tcpdump starts
sleep 2

# Run the insecure Java program
java InsecureTokenGenerator

# Give tcpdump some time to capture any last packets
sleep 2

# Stop tcpdump
kill $TCPDUMP_PID

# Wait for tcpdump to fully shut down
wait $TCPDUMP_PID 2>/dev/null
