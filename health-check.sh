#!/bin/bash

# Jenkins Health Check Script
# This script checks if Jenkins is running properly

echo "🏥 Jenkins Health Check"
echo "======================"

# Check if Jenkins is responding
if curl -s -f http://localhost:8080/login > /dev/null; then
    echo "✅ Jenkins is responding on port 8080"
else
    echo "❌ Jenkins is not responding on port 8080"
    exit 1
fi

# Check if Jenkins is ready
if curl -s http://localhost:8080/api/json | grep -q '"mode":"NORMAL"'; then
    echo "✅ Jenkins is in NORMAL mode"
else
    echo "⚠️  Jenkins might still be starting up"
fi

# Check Node.js availability
if command -v node > /dev/null; then
    echo "✅ Node.js is available: $(node --version)"
else
    echo "❌ Node.js is not available"
fi

# Check npm availability
if command -v npm > /dev/null; then
    echo "✅ npm is available: $(npm --version)"
else
    echo "❌ npm is not available"
fi

# Check disk space
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -lt 80 ]; then
    echo "✅ Disk usage is healthy: ${DISK_USAGE}%"
else
    echo "⚠️  High disk usage: ${DISK_USAGE}%"
fi

echo ""
echo "🎯 Jenkins URL: https://jenkins-react-vite-npm.onrender.com"
echo "📊 Health check completed"