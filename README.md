```text
  __  __ ___ ___   _       __ __   ___   _ _    _  __   _   _  _    _____   _____ ___ ___ ___ ___  ___   ___ _____ _   ___ _  __
 |  \/  | __/ __| /_\     / / \ \ / / | | | |  | |/ /  /_\ | \| |  / _ \ \ / / __| _ \ _ \_ _|   \| __| / __|_   _/_\ / __| |/ /
 | |\/| | _|\__ \/ _ \   / /   \ V /| |_| | |__| ' <  / _ \| .` | | (_) \ V /| _||   /   /| || |) | _|  \__ \ | |/ _ \ (__| ' < 
 |_|  |_|___|___/_/ \_\ /_/     \_/  \___/|____|_|\_\/_/ \_\_|\_|  \___/ \_/ |___|_|_\_|_\___|___/|___| |___/ |_/_/ \_\___|_|\_\
```

====================================================================

OVERVIEW

This project provides an upgraded Vulkan/Mesa stack for Batocera v42
on both Raspberry Pi 4 and Raspberry Pi 5.

It replaces Batocera's built-in Vulkan loader and V3DV Mesa driver
with newer, tuned versions that improve rendering accuracy and fix
several compatibility issues (incl. Mario Kart Double Dash).

VERSIONS

Vulkan Loader : 1.4.328.1 (libvulkan.so.1.4.328)

Mesa (V3DV) : 25.3.0 (Broadcom Vulkan driver)

Driver select : Auto (RPi4 → cortex-a72, RPi5 → cortex-a76)

ICD files : CPU specific JSON (a72 / a76)

Optional fix : GM4E01.ini for Mario Kart Double Dash brightness

====================================================================

DEMO - MARIO KART DOUBLE DASH (MKDD)

Bright/dark tint issue on RPi5 is fixed using this Mesa/Vulkan stack.

[![## 🎬 Demonstration – Mario Kart Double Dash Fix](https://fs-prod-cdn.nintendo-europe.com/media/images/10_share_images/games_15/gamecube_12/SI_GCN_MarioKartDoubleDash_image1600w.jpg)](https://github.com/user-attachments/assets/d9545f20-2665-40fe-b4fb-ada9b42ea204)

<!-- [![## 🎬 Demonstration – Mario Kart Double Dash Fix](https://fs-prod-cdn.nintendo-europe.com/media/images/10_share_images/games_15/gamecube_12/SI_GCN_MarioKartDoubleDash_image1600w.jpg)](https://release-assets.githubusercontent.com/github-production-release-asset/1084304914/24dd3c3d-ebc9-4de0-9c07-cdcb88920ce8?sp=r&sv=2018-11-09&sr=b&spr=https&se=2025-11-17T09%3A49%3A55Z&rscd=attachment%3B+filename%3DMKDD-Tint-Fix-RPi5.webm&rsct=application%2Foctet-stream&skoid=96c2d410-5711-43a1-aedd-ab1947aa7ab0&sktid=398a6654-997b-47e9-b12b-9515b896b4de&skt=2025-11-17T08%3A49%3A48Z&ske=2025-11-17T09%3A49%3A55Z&sks=b&skv=2018-11-09&sig=ukl5CZ18rwSnMRA2txJ3bgRREHTVaK46h4DFiReFiUs%3D&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmVsZWFzZS1hc3NldHMuZ2l0aHVidXNlcmNvbnRlbnQuY29tIiwia2V5Ijoia2V5MSIsImV4cCI6MTc2MzM3MTE4OCwibmJmIjoxNzYzMzY5Mzg4LCJwYXRoIjoicmVsZWFzZWFzc2V0cHJvZHVjdGlvbi5ibG9iLmNvcmUud2luZG93cy5uZXQifQ.ROOlRvb6ODUAqfyDPA0CVm3mcnvvMBEPdFKOCsgmvBs&response-content-disposition=attachment%3B%20filename%3DMKDD-Tint-Fix-RPi5.webm&response-content-type=application%2Foctet-stream) -->

====================================================================

LAYOUT OF THE OVERRIDE STACK

The override directory is extracted under:

/userdata/system/mesa-vulkan-25.3.0-1.4.328.1

Directory layout:

```text
mesa-vulkan-25.3.0-1.4.328.1/
  lib/
    libvulkan.so
    libvulkan.so.1
    libvulkan.so.1.4.328
    rpi4/libvulkan_broadcom.so     # V3DV for Raspberry Pi 4 (cortex-a72)
    rpi5/libvulkan_broadcom.so     # V3DV for Raspberry Pi 5 (cortex-a76)
  icd/
    broadcom_icd.cortex-a72.json   # ICD for RPi4
    broadcom_icd.cortex-a76.json   # ICD for RPi5
```

====================================================================

INSTALLATION (RPI4 & RPI5)

Run this directly on your Batocera device (RPi4 or RPi5):

```text
curl -fsSL https://raw.githubusercontent.com/tbrautaset/rpi-batocera-mesa-vulkan/main/install.sh | sh
```

The installer will:

Detect whether you are on RPi4 or RPi5

Download the latest mesa-vulkan-stack.tar.gz from GitHub

Install to:

/userdata/system/mesa-vulkan-25.3.0-1.4.328.1

Select the correct V3DV driver + ICD config

Update /userdata/system/.profile to prepend the new stack

Make the override persistent across reboots

Finally: REBOOT Batocera to activate the new stack.

====================================================================
<!-- 
UPDATE EXISTING INSTALLATION

If you already have an older version installed, run:

```text
curl -fsSL https://raw.githubusercontent.com/tbrautaset/rpi-batocera-mesa-vulkan/main/self-update.sh | sh

```

This will:

Detect CPU (RPi4 vs RPi5)

Download newest mesa-vulkan-stack.tar.gz

Replace mesa-vulkan-25.3.0-1.4.328.1 with the updated build

Keep your .profile configuration

Try to restart EmulationStation automatically
(or tell you to reboot if needed)

==================================================================== -->

OPTIONAL: MARIO KART DOUBLE DASH FIX (GM4E01.INI)

To fix the dark / dim image for Mario Kart Double Dash (GameCube):

Create this file on Batocera:

/userdata/system/configs/dolphin-emu/GameSettings/GM4E01.ini

Place the per-game Dolphin config there. Dolphin will automatically
apply the fix for the GM4E01 title.

====================================================================

VERIFICATION

To verify that the override is active:

```text
curl -fsSL https://raw.githubusercontent.com/tbrautaset/rpi-batocera-mesa-vulkan/main/verify.sh | sh
```

The verify script will show:

Vulkan loader version (libvulkan.so)

Mesa / V3DV version from libvulkan_broadcom.so

Which ICD file is used (a72 vs a76)

Effective library path seen by Vulkan

====================================================================

UNINSTALL (REVERT TO STOCK BATOCERA)

To remove the override and go back to Batocera defaults:

```text
curl -fsSL https://raw.githubusercontent.com/tbrautaset/rpi-batocera-mesa-vulkan/main/uninstall.sh | sh
```

The uninstaller will:

Delete mesa-vulkan-25.3.0-1.4.328.1 from /userdata/system

Clean any .profile/custom.sh entries added by the installer

Restore stock Batocera Vulkan/Mesa libraries

====================================================================

SAMPLE VULKAN OUTPUT (RPI5)

Typical Vulkan info dump after installation:

Vulkan Instance Version: 1.4.328
driverVersion: 25.3.0 (Mesa 25.3.0)
deviceName: V3D 7.1.7.0

====================================================================

NOTES

Target: Batocera v42, RPi4, RPi5

Fully reversible, no core system files modified

All override files live under /userdata/system

Scripts are idempotent (safe to run multiple times)

Can coexist with other tweaks as long as .profile is handled
with care
