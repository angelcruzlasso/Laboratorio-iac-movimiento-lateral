#!/bin/bash
# Script to install required dependencies for the Lateral Movement Lab

set -e

echo "=========================================="
echo "  INSTALLING LAB DEPENDENCIES"
echo "=========================================="
echo ""

# Install pip packages
echo "Installing Python packages..."
pip install --quiet ansible-core ansible-lint yamllint 2>/dev/null || pip install ansible-core ansible-lint yamllint

# Install Ansible collections
echo ""
echo "Installing Ansible collections..."
if ! ansible-galaxy collection list community.docker &>/dev/null; then
    ansible-galaxy collection install community.docker
fi

if ! ansible-galaxy collection list community.general &>/dev/null; then
    ansible-galaxy collection install community.general
fi

if ! ansible-galaxy collection list vyos.vyos &>/dev/null; then
    ansible-galaxy collection install vyos.vyos || echo "vyos.vyos collection optional for manual config"
fi

echo ""
echo "=========================================="
echo "  DEPENDENCIES INSTALLED"
echo "=========================================="

# Verify installations
echo ""
echo "Verifying installations..."
echo "Ansible version: $(ansible --version | head -1)"
echo "Ansible-lint: $(ansible-lint --version | head -1)"
echo "Collections:"
ansible-galaxy collection list --only-installed 2>/dev/null || true

echo ""
echo "Done! You can now run the lab deployment."