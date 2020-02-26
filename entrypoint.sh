#!/bin/bash
set -e

# Use /home/runner/work as both PWD and the work directory configured for the runner
mkdir -p work
cd work

# Configure the runner
/opt/actions-runner/config.sh \
    --replace \
    --token "${TOKEN}" \
    --unattended \
    --url "${REPOSITORY}" \
    --work "${PWD}"

# Off to the races
exec /bin/bash /opt/actions-runner/run.sh