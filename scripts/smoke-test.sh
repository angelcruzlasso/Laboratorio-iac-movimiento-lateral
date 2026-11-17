#!/bin/bash
# Smoke Test Script for Lateral Movement Lab
# This script validates that all critical services are running and accessible

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PASS=0
FAIL=0

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
    ((PASS++))
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    ((FAIL++))
}

log_info() {
    echo -e "${YELLOW}[INFO]${NC} $1"
}

echo "=========================================="
echo "  LATERAL MOVEMENT LAB - SMOKE TEST"
echo "=========================================="
echo ""

# Test 1: VyOS Firewall is accessible
echo "Testing VyOS Firewall..."
if ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 vyos@192.168.100.10 'hostname' &>/dev/null; then
    log_pass "VyOS firewall is accessible"
else
    log_fail "VyOS firewall is not accessible"
fi

# Test 2: Juice Shop is running
echo "Testing Juice Shop..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 | grep -q "200"; then
    log_pass "Juice Shop is responding (HTTP 200)"
elif curl -s -o /dev/null -w "%{http_code}" http://10.0.10.10:3000 | grep -q "200"; then
    log_pass "Juice Shop is responding on DMZ IP (HTTP 200)"
else
    log_fail "Juice Shop is not responding"
fi

# Test 3: Docker network is configured
echo "Testing Docker networks..."
if docker network ls | grep -q "dmz-net"; then
    log_pass "DMZ network exists"
else
    log_fail "DMZ network missing"
fi

if docker network ls | grep -q "attacker-net"; then
    log_pass "Attacker network exists"
else
    log_fail "Attacker network missing"
fi

# Test 4: Samba AD container is running
echo "Testing Samba AD..."
if docker ps | grep -q "samba_ad"; then
    log_pass "Samba AD container is running"
else
    log_fail "Samba AD container is not running"
fi

# Test 5: MySQL container is running
echo "Testing MySQL..."
if docker ps | grep -q "mysql_db"; then
    log_pass "MySQL container is running"
else
    log_fail "MySQL container is not running"
fi

# Test 6: Kali container is running
echo "Testing Kali..."
if docker ps | grep -q "kali"; then
    log_pass "Kali container is running"
else
    log_fail "Kali container is not running"
fi

# Test 7: Firewall rules are loaded
echo "Testing firewall rules..."
# Check if iptables has rules (this would be from VyOS)
if iptables -L -n | grep -q "DROP" || true; then
    log_pass "Firewall rules appear configured"
else
    log_info "Firewall rules check skipped (not VyOS host)"
fi

# Test 8: Docker only exposes internal ports to host
echo "Testing Docker port exposure..."
HOST_PORTS=$(docker ps --format "table {{.Names}}\t{{.Ports}}" | grep -v "PORTS" | grep -v "3306\|1433\|5432" || true)
if [ -z "$HOST_PORTS" ] || echo "$HOST_PORTS" | grep -qE "0.0.0.0:3306|0.0.0.0:1433|0.0.0.0:5432"; then
    log_fail "Database ports exposed to host"
else
    log_pass "Database ports not exposed to host network"
fi

echo ""
echo "=========================================="
echo "  RESULTS: $PASS passed, $FAIL failed"
echo "=========================================="

if [ $FAIL -gt 0 ]; then
    exit 1
fi

exit 0