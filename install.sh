#!/usr/bin/env bash
# Install the Arterial Plymouth theme (needs root; rebuilds the initramfs).
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
[ -f "$HERE/background.png" ] || "$HERE/build-assets.sh"
sudo mkdir -p /usr/share/plymouth/themes/arterial
sudo cp "$HERE"/*.script "$HERE"/*.plymouth "$HERE"/*.png "$HERE"/LICENSE /usr/share/plymouth/themes/arterial/
sudo plymouth-set-default-theme -R arterial     # -R rebuilds the initramfs
echo "Set 'arterial' as default. Ensure 'splash' is on the kernel cmdline and 'plymouth' is in HOOKS."
