# Overview
This is a repo to get to know Configu and demo it in action. We will create a monitoring stack of Prometheus, Grafana, and Loki inside an EC2 instance running on Docker Compose. Terraform is used to stand up the infrastructure and Ansible is used for configuration management. We use configu as a centralized configuration store.

### Terraform

Let's first get env0 ready for Terraform. Run this command:
```bash
terraform login backend.api.env0.com
```

Then follow the prompts to login.

