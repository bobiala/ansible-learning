#!/bin/bash
set -euo pipefail

getent passwd postgres > /tmp/uid.txt

locale-gen
docker-entrypoint.sh "$@"
