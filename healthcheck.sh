#!/usr/bin/env bash
set -euo pipefail

if pgrep -f 'WindroseServer-Win64-Shipping.exe' >/dev/null 2>&1; then
    exit 0
fi

exit 1
