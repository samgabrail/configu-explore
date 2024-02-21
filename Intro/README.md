# Overview
Intro to Configu

## Linux Install

```bash
curl https://cli.configu.com/install.sh | sh
```

## Create an Example Schema

```bash
configu init --getting-started
```

## Login to Configu SaaS

```bash
configu login
```

## Set Config Values

The Upsert command is used to create, update, or delete Configs in a ConfigStore.

```bash
configu upsert \
--store 'configu' --set 'Staging' --schema './start.cfgu.json' \
--config 'GREETING=bonjour'

configu upsert \
--store 'configu' --set 'QA' --schema './start.cfgu.json' \
--config 'SUBJECT=Sam'
```

## Get Config Values

The Export command is used to fetch and validate Configs as an Object from a ConfigStore as a `.json` file.

```bash
configu eval \
--store 'configu' --set 'QA' --schema './start.cfgu.json' \
| configu export \
--format 'JSON' \
> 'greeting.json'
```

Export to a `.env` file.

```bash
configu eval \
--store 'configu' --set 'QA' --schema './start.cfgu.json' \
| configu export \
--format "Dotenv" \
> ".env"
```

Export to a `KubernetesConfigMap` file.

```bash
configu eval \
--store 'configu' --set 'QA' --schema './start.cfgu.json' \
| configu export \
--format 'KubernetesConfigMap' \
> "kubeconfigmap.yaml"
```

Export to a `Terraform tfvars` file.

```bash
configu eval \
--store 'configu' --set 'QA' --schema './start.cfgu.json' \
| configu export \
--format 'TerraformTfvars' \
> "var.auto.tfvars"
```
