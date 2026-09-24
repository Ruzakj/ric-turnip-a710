#!/usr/bin/env bash
set -euo pipefail
variant="${1:?variant}"
case "$variant" in
  stable)
    echo "Stable: upstream optimization + A710 descriptor; runtime recommendation TU_DEBUG=sysmem"
    ;;
  performance)
    echo "Performance: optimized release build; no unsafe GMEM forcing"
    export RIC_PERF=1
    ;;
  experimental)
    echo "Experimental: GMEM-capable test profile; do not use as default"
    export RIC_EXPERIMENTAL=1
    ;;
  *) exit 2 ;;
esac
