# Security Policy

## What is this project?

This is a cybersecurity lab for educational purposes only. It demonstrates:
- Infrastructure as Code (Terraform + Ansible)
- Network segmentation and firewall rules
- Container isolation for security testing
- Lateral movement simulation
- Security monitoring with Wazuh SIEM

## Disclaimer ⚠️

**This repository is for EDUCATIONAL and RESEARCH purposes only. Do not use for unauthorized penetration testing or actual attacks.**

## Security Considerations

### What's in this repo (safe)
- Terraform/ Ansible configuration code
- Docker Compose templates
- Firewall rules as code
- Documentation and tests

### What's NOT in this repo
- Real passwords (use vault.yml.example as template)
- Terraform state files (.tfstate)
- Private SSH keys
- Network credentials
- Any sensitive operational data

## Reporting a Vulnerability

Since this is an educational lab:
1. There are no production vulnerabilities to report
2. If you find security issues in the code/configuration:
   - Open an issue with label "security"
   - Or contact the maintainers

## License

This project is for educational use only. Use at your own risk.