#!/usr/bin/env bash
set -euo pipefail
variant="${1:?variant}"
rm -rf stage dist
mkdir -p stage dist
lib="$(find build-"$variant" -type f \( -name 'libvulkan_freedreno.so' -o -name 'libvulkan_freedreno.so.*' \) | head -n1)"
test -n "$lib"
cp "$lib" stage/libvulkan_freedreno.so
cat > stage/meta.json <<EOF
{"schemaVersion":1,"name":"RIC Turnip A710 ${variant}","description":"iQOO Z9x / Snapdragon 6 Gen 1 / Adreno 710 experimental Turnip build","author":"RIC","packageVersion":"1","vendor":"Mesa Turnip"}
EOF
cat > stage/README.txt <<EOF
RIC Turnip A710 - ${variant}
Target: iQOO Z9x / Snapdragon 6 Gen 1 / Adreno 710
Stable/Performance: prefer TU_DEBUG=sysmem for minimum rendering artifacts.
Experimental: test-only; GMEM may cause graphical corruption.
Winlator may require WRAPPER_BLIT=1.
EOF
(cd stage && zip -9 -r "../dist/RIC-Turnip-A710-${variant}.zip" .)
