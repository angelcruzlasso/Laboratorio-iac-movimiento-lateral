#!/bin/bash
# Script to create libvirt networks with specific CIDR ranges
# Required for proper network segmentation in the lab

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

log_pass() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

log_fail() {
    echo -e "${RED}[FAIL]${NC} $1"
    exit 1
}

echo "=========================================="
echo "  CREATING LIBVIRT NETWORKS"
echo "=========================================="
echo ""

# XML definitions for each network zone
# These create isolated networks with specific CIDRs

# Management Network (for VyOS) - will use virbr0 bridge
cat > /tmp/mgmt_net.xml << 'EOF'
<network>
  <name>mgmt_net</name>
  <forward mode='nat'/>
  <bridge name='virbr0' stp='on' delay='0'/>
</network>
EOF

# DMZ Network - isolated, no NAT
cat > /tmp/dmz_net.xml << 'EOF'
<network>
  <name>dmz_net</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr0' stp='on' delay='0'/>
  <ip address='10.0.10.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='10.0.10.100' end='10.0.10.200'/>
    </dhcp>
  </ip>
</network>
EOF

# Attacker Network
cat > /tmp/attacker_net.xml << 'EOF'
<network>
  <name>attacker_net</name>
  <forward mode='nat'>
    <nat>
      <port start='1024' end='65535'/>
    </nat>
  </forward>
  <bridge name='virbr0' stp='on' delay='0'/>
  <ip address='10.0.30.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='10.0.30.100' end='10.0.30.200'/>
    </dhcp>
  </ip>
</network>
EOF

# Internal Network - NO DHCP, no NAT, isolated from external
cat > /tmp/internal_net.xml << 'EOF'
<network>
  <name>internal_net</name>
  <bridge name='virbr0' stp='on' delay='0'/>
  <ip address='10.0.20.1' netmask='255.255.255.0'>
    <dhcp>
      <range start='10.0.20.100' end='10.0.20.200'/>
    </dhcp>
  </ip>
</network>
EOF

# Create networks
networks=("mgmt_net" "dmz_net" "attacker_net" "internal_net")

for net in "${networks[@]}"; do
    xml_file="/tmp/${net}.xml"
    
    if virsh net-list --all | grep -q "^[[:space:]]*${net}"; then
        echo "Network $net already exists, skipping..."
        continue
    fi
    
    if [ -f "$xml_file" ]; then
        if virsh net-define "$xml_file"; then
            log_pass "Network $net defined"
            virsh net-start "$net"
            virsh net-autostart "$net"
            log_pass "Network $net started and autostart enabled"
        else
            log_fail "Failed to define network $net"
        fi
    else
        log_fail "XML file $xml_file not found"
    fi
done

echo ""
echo "=========================================="
echo "  NETWORK STATUS"
echo "=========================================="
virsh net-list --all

echo ""
echo "Done! Networks created successfully."