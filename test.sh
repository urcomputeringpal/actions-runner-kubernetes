#!/bin/bash
# A tiny pre-flight check to confirm that this image is suitable for use
set -ex

which docker
which git
which ping
whoami
sudo whoami