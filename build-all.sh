#!/usr/bin/env bash

# Stop immediately if any environment fails.
set -euo pipefail

# Run correctly even when the script is started from another directory.
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

for environment in dev staging prod; do
  echo "Deploying ${environment}..."
  terraform -chdir="${PROJECT_DIR}/environments/${environment}" init
  terraform -chdir="${PROJECT_DIR}/environments/${environment}" apply
done
