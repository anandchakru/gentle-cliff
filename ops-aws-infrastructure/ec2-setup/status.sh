#!/bin/bash

# Status check script for gentle-cliff API Service

echo "=== gentle-cliff API Service Status ==="
echo

# Service status
echo "=== Service Status ==="
if systemctl is-active --quiet gentle-cliff-api.service; then
    echo "✅ Service is RUNNING"
else
    echo "❌ Service is NOT RUNNING"
fi
echo
sudo systemctl status gentle-cliff-api.service --no-pager -l
echo

# Recent logs
echo "=== Recent Logs (Last 20 entries) ==="
sudo journalctl -u gentle-cliff-api.service -n 20 --no-pager
echo

# Log files
echo "=== Application Log Files ==="
if ls /opt/gentle-cliff/logs/gentle-cliff-*.log 1> /dev/null 2>&1; then
    ls -la /opt/gentle-cliff/logs/gentle-cliff-*.log
    echo
    echo "Latest log file (last 10 lines):"
    tail -n 10 /opt/gentle-cliff/logs/gentle-cliff-$(date +%Y%m%d).log 2>/dev/null || echo "No log file for today"
else
    echo "No log files found"
fi
echo

# Current JAR
echo "=== Current Application JAR ==="
if [ -f "/opt/gentle-cliff/lib/app.jar" ]; then
    ls -la /opt/gentle-cliff/lib/app.jar
else
    echo "❌ No JAR file found at /opt/gentle-cliff/lib/app.jar"
fi
echo

# System resources
echo "=== System Resources ==="
echo "Memory usage:"
free -h
echo
echo "Disk usage for /opt/gentle-cliff:"
du -sh /opt/gentle-cliff/* 2>/dev/null || echo "Could not calculate disk usage"
echo

# Service uptime
echo "=== Service Uptime ==="
if systemctl is-active --quiet gentle-cliff-api.service; then
    MAIN_PID=$(systemctl show gentle-cliff-api.service --property=MainPID --value)
    if [ "$MAIN_PID" != "0" ] && [ -n "$MAIN_PID" ]; then
        echo "Service uptime: $(ps -o etime= -p "$MAIN_PID" 2>/dev/null | xargs || echo "Unable to determine")"
    else
        echo "Unable to determine service uptime"
    fi
else
    echo "Service is not running"
fi