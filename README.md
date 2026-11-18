# Session 7: Reusable Terraform EC2 Module

## Goal

This project demonstrates one reusable AWS EC2 child module used by three independent root modules:

- Development
- Staging
- Production

The environments use different instance names, instance types, and tags.

## Project Structure

```text
Phase2_Session7/
├── modules/
│   └── ec2/
│       ├── data.tf
│       ├── ec2.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── versions.tf
│   │   └── outputs.tf
│   ├── staging/
│   │   ├── main.tf
│   │   ├── provider.tf
│   │   ├── versions.tf
│   │   └── outputs.tf
│   └── prod/
│       ├── main.tf
│       ├── provider.tf
│       ├── versions.tf
│       └── outputs.tf
└── README.md
```

## Root Module vs. Child Module

### Child Module

`modules/ec2` is the reusable child module. It contains the shared EC2 resource definition.

It accepts three inputs:

- `instance_name`
- `instance_type`
- `tags`

It returns the EC2 `instance_id`.

The child module does not configure the AWS provider because provider configuration belongs to the calling root module.

### Root Modules

Each directory under `environments` is a separate root module:

- `environments/dev`
- `environments/staging`
- `environments/prod`

A root module is the directory where Terraform commands are run. Each root module:

1. Configures the AWS provider.
2. Calls the reusable EC2 child module.
3. Supplies environment-specific values.
4. Maintains its own Terraform state.

The configurations use:

- Development: `education-dev-ec2` with `t3.micro`
- Staging: `education-staging-ec2` with `t3.small`
- Production: `education-prod-ec2` with `t3.medium`

These instance types may create AWS charges. Always review the Terraform plan and AWS pricing before applying.

## Prerequisites

- Terraform installed
- AWS CLI installed
- AWS credentials configured:

```bash
aws configure
```

Confirm the active identity:

```bash
aws sts get-caller-identity
```

## Run One Environment Only

Run Terraform from only the environment you want to manage. The following example uses Development:

```bash
cd environments/dev
terraform init
terraform plan
terraform apply
```

`terraform init` downloads the AWS provider and loads the child module.

`terraform plan` previews the EC2 instance without creating it.

`terraform apply` asks for confirmation before creating it. Do not approve the apply unless you intend to create a billable AWS resource.

Do not run Terraform from the project root because the project root is documentation only.

## Clean Up After an Apply

If you create the Development instance, remove it from the same environment directory:

```bash
cd environments/dev
terraform destroy
```

Each environment has independent state. Destroying Development does not destroy Staging or Production.

## Key Lesson

The EC2 code is written once in `modules/ec2`. The three root modules reuse it with different values. This reduces duplicated resource code and gives every environment a consistent EC2 configuration.
