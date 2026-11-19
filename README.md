# Session 7: Reusable Terraform EC2 Module and S3 State

## Goal

This project demonstrates one reusable AWS EC2 child module used by three
independent Terraform root modules:

- Development
- Staging
- Production

Each environment has different EC2 settings and stores its Terraform state in
its own encrypted S3 backend.

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
│   │   ├── network.tf
│   │   ├── provider.tf
│   │   ├── versions.tf
│   │   └── outputs.tf
│   ├── staging/
│   │   ├── main.tf
│   │   ├── network.tf
│   │   ├── provider.tf
│   │   ├── versions.tf
│   │   └── outputs.tf
│   └── prod/
│       ├── main.tf
│       ├── network.tf
│       ├── provider.tf
│       ├── versions.tf
│       └── outputs.tf
├── run-first.sh
├── build-all.sh
├── destroy-all.sh
└── README.md
```

## Root Module vs. Child Module

### Child Module

`modules/ec2` is the reusable child module. It contains the shared EC2 resource
definition.

It accepts:

- `instance_name`
- `instance_type`
- `subnet_id`
- `tags`

It returns the EC2 `instance_id`.

The child module does not configure the AWS provider or backend. Those
configurations belong to each calling root module.

### Root Modules

Each directory under `environments` is a separate root module:

- `environments/dev`
- `environments/staging`
- `environments/prod`

Each root module configures AWS, creates its environment-specific network
resources, calls the EC2 module, and maintains independent remote state.

The environments use:

- Development: `education-dev-ec2` with `t3.micro`
- Staging: `education-staging-ec2` with `t3.small`
- Production: `education-prod-ec2` with `t3.medium`

These resources may create AWS charges. Review every Terraform plan and AWS
pricing before approving an apply.

## Prerequisites

- Terraform 1.10 or newer
- AWS CLI
- AWS credentials with permission to manage EC2, networking, and the S3 state
  buckets

Configure and verify the active AWS identity:

```bash
aws configure
aws sts get-caller-identity
```

## S3 Remote State

The `backend "s3"` block in each environment's `versions.tf` stores state in a
separate bucket:

| Environment | Bucket | State object |
| --- | --- | --- |
| Development | `education-dev-s3` | `terraform.tfstate` |
| Staging | `education-staging-s3` | `terraform.tfstate` |
| Production | `education-prod-s3` | `terraform.tfstate` |

All backends use `us-east-1`, server-side encryption, and native S3 lock files.
Terraform creates a temporary `terraform.tfstate.tflock` object while a state
operation is running. This prevents two Terraform processes from changing the
same state simultaneously.

The backend buckets must exist before `terraform init`. Terraform cannot create
the bucket from the same root module that uses it as a backend.

## First-Time Setup

Run the bucket script once, before deploying any environment:

```bash
bash run-first.sh
```

The script creates:

- `education-dev-s3`
- `education-staging-s3`
- `education-prod-s3`

S3 bucket names are globally unique. If another AWS account owns one of these
names, change that bucket name in both `run-first.sh` and the matching
`environments/<environment>/versions.tf` backend block.

If local state already exists and must be moved to S3, initialize that
environment with migration enabled:

```bash
terraform -chdir=environments/dev init -migrate-state
```

Do not delete a local state file until `terraform state pull` confirms that the
remote state can be read successfully.

## Deploy All Environments

After the buckets exist, run:

```bash
./build-all.sh
```

The script processes `dev`, `staging`, and `prod` in that order. For each
environment it:

1. Runs `terraform init` to configure the S3 backend and install dependencies.
2. Runs `terraform apply`.
3. Waits for approval before creating or changing infrastructure.

Each environment has a separate confirmation prompt.

## Run One Environment

To manage only one environment, use its root module directly. For example:

```bash
terraform -chdir=environments/dev init
terraform -chdir=environments/dev plan
terraform -chdir=environments/dev apply
```

Do not run Terraform from the project root because it is not a Terraform root
module.

## Destroy All Environments

Run:

```bash
./destroy-all.sh
```

The script initializes and destroys the environments in reverse deployment
order: `prod`, `staging`, then `dev`. Each environment has a separate
confirmation prompt.

Destroying the infrastructure does not delete the S3 buckets. The remote state
remains available so Terraform can continue tracking each environment. Delete
the buckets only when their state is no longer needed.

To destroy only one environment:

```bash
terraform -chdir=environments/dev destroy
```

## State Lock Recovery

Terraform normally removes its S3 lock file automatically. If an operation
terminates unexpectedly and leaves a stale lock, copy the lock ID from
Terraform's error and run this inside the affected environment:

```bash
terraform -chdir=environments/dev force-unlock LOCK_ID
```

Only force-unlock a state after confirming that no other Terraform operation is
using it.

## Key Lesson

The EC2 code is written once in `modules/ec2` and reused by three root modules.
Each root module has isolated infrastructure and remote state, while the helper
scripts provide a consistent workflow for creating backend buckets, deploying
all environments, and cleaning up the infrastructure.
