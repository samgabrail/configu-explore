# Overview
This is a repo to get to know Configu and demo it in action. We will create a monitoring stack of Prometheus, Grafana, and Loki inside an EC2 instance running on Docker Compose. Terraform is used to stand up the infrastructure and Ansible is used for configuration management. We use configu as a centralized configuration store.

## Configu

Let's set up our configurations ahead of time. You can do this via the UI or cli. We will do this once for dev and once for prod:

```bash
configu upsert --store 'configu' --set 'Development/Monitoring' --schema './monitoring.cfgu.json' \
-c 'prefix=configu' \
-c 'region=us-east-1' \
-c 'address_space=10.0.0.0/16' \
-c 'subnet_prefix=10.0.10.0/24' \
-c 'instance_type=t2.micro' \
-c 'my_aws_key=mykey.pem'
```

```bash
configu upsert --store 'configu' --set 'Production/Monitoring' --schema './monitoring.cfgu.json' \
-c 'prefix=configu' \
-c 'region=us-west-1' \
-c 'address_space=10.1.0.0/16' \
-c 'subnet_prefix=10.1.10.0/24' \
-c 'instance_type=t2.micro' \
-c 'my_aws_key=mykey.pem'
```

We can now retrieve these values from within the pipeline.

### Terraform

Let's first get env0 ready for Terraform. Run this command:
```bash
terraform login backend.api.env0.com
```

Then follow the prompts to login.

