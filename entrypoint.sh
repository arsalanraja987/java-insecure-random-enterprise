#!/bin/bash

echo "📡 Starting tcpdump to monitor outbound network calls..."
tcpdump -i any -n -w /app/outbound_traffic.pcap &
TCPDUMP_PID=$!

echo "🚀 Running Java app..."
java InsecureRandomGenerator

echo "✅ Java app finished. Stopping tcpdump..."
kill $TCPDUMP_PID

echo "📁 Outbound traffic capture saved to: /app/outbound_traffic.pcap"
