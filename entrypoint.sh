#!/bin/bash
set -e

# Use /work as both PWD and the work directory configured for the runner
cd /work

# Configure the runner
/opt/actions-runner/config.sh \
    --replace \
    --token "${TOKEN}" \
    --unattended \
    --url "${REPOSITORY}" \
    --work /work

# Off to the races
cd /opt/actions-runner
/opt/actions-runner/bin/runsvc.sh
