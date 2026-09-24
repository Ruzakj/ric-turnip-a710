#!/usr/bin/env bash
set -euo pipefail
variant="${1:?variant}"
cd mesa
NDK="$ANDROID_NDK_HOME"
cat > ../android-aarch64.ini <<EOF
[binaries]
c = '$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android28-clang'
cpp = '$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/aarch64-linux-android28-clang++'
ar = '$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-ar'
strip = '$NDK/toolchains/llvm/prebuilt/linux-x86_64/bin/llvm-strip'
pkg-config = 'pkg-config'

[host_machine]
system = 'android'
cpu_family = 'aarch64'
cpu = 'armv8-a'
endian = 'little'

[properties]
needs_exe_wrapper = true
EOF
opts=(-Dplatforms=android -Dplatform-sdk-version=28 -Dandroid-stub=true -Dvulkan-drivers=freedreno -Dgallium-drivers= -Dbuildtype=release -Db_lto=true -Db_ndebug=true)
if [[ "$variant" == performance ]]; then opts+=(-Dc_args=-O3 -Dcpp_args=-O3); fi
meson setup ../build-"$variant" --cross-file ../android-aarch64.ini "${opts[@]}"
ninja -C ../build-"$variant"
