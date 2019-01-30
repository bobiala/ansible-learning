#!/bin/bash
set -euo pipefail

locale-gen
docker-entrypoint.sh "$@"
