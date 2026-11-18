#!/usr/bin/env bash

# Stop immediately if any environment fails.
set -euo pipefail

# Run correctly even when the script is started from another directory.
PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Destroy in reverse deployment order.
for environment in prod staging dev; do
  echo "Destroying ${environment}..."
  terraform -chdir="${PROJECT_DIR}/environments/${environment}" init
  terraform -chdir="${PROJECT_DIR}/environments/${environment}" destroy
done
