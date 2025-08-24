#!/usr/bin/env bash
set -euo pipefail
# Copy example settings if none present
if [ ! -f local.settings.json ]; then
  cp local.settings.example.json local.settings.json
fi
func start --python
