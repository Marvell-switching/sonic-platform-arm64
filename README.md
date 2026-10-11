# Marvell Prestera Platform specific directories and REPOs

### Platform-device initialisation and monitoring rules (sonic-platform-marvell)

---

<a href="https://www.marvell.com/"><img src="https://www.marvell.com/content/dam/marvell/en/rebrand/marvell-logo3.svg" alt="Marvell Technologies" width="200"></a>

## Directories and Repositories

| Directory | Description | GitHub Link |
|-----------|-------------|-------------|
| <code>platform/<wbr>marvell-prestera/</code> | Main directory with sai.mk, docker-syncd-mrvl-prestera and submodules | [sonic-net/<wbr>sonic-buildimage](https://github.com/sonic-net/sonic-buildimage.git) |
| <code>platform/<wbr>marvell-prestera/<wbr>mrvl-prestera/</code> | Kernel Driver (.ko) Sources providing Interrupt, DMA, MBUS, Ethernet and legacy DTB files | [Marvell-switching/<wbr>mrvl-prestera](https://github.com/Marvell-switching/mrvl-prestera.git) |
| <code>platform/<wbr>marvell-prestera/<wbr>sonic-platform-marvell/</code> | Platform-device initialisation and monitoring rules | [Marvell-switching/<wbr>sonic-platform-arm64](https://github.com/Marvell-switching/sonic-platform-arm64.git) |
| <code>device/<wbr>marvell/</code> | HWSKU — profiles, ports, ini, XML configurations for boards supported by Marvell | [sonic-net/<wbr>sonic-buildimage](https://github.com/sonic-net/sonic-buildimage.git) |

## Boards / Platforms

| ASIC | SONiC device | CPU | Architecture | Platform |
|------|--------------|-----|---------------------|-----------------|
| AC5X-RD | `arm64-marvell_rd98DX35xx_cn9131-r0` | CN913x | `arm64` | `marvell-prestera` |
| AC5P-RD | `arm64-marvell_rd98DX45xx_cn9131-r0` | CN913x | `arm64` | `marvell-prestera` |
| AC3X | `armhf-nokia_ixs7215_52x-r0` | CN913x | `armhf` | `marvell-prestera` |
| Falcon-12.8T | `x86_64-marvell_db98cx8580_16cd-r0` | Xeon | `amd64` | `marvell-prestera` |
| Falcon-6.4T | `x86_64-marvell_db98cx8580_32cd-r0` | Xeon | `amd64` | `marvell-prestera` |
| Falcon-3.2T | `x86_64-marvell_db98cx8514_10cc-r0` | Xeon | `amd64` | `marvell-prestera` |
| Falcon-2T | `x86_64-marvell_db98cx8522_10cc-r0` | Xeon | `amd64` | `marvell-prestera` |
| Teralynx-10 | `x86_64-marvell_dbmvtx9180-r0` | Xeon D15xx | `amd64` | `marvell-teralynx` |

## Repository Structure

This repository is checked out under `platform/marvell-prestera/sonic-platform-marvell/` in [sonic-buildimage](https://github.com/sonic-net/sonic-buildimage.git). It contains one top-level directory per supported board (`DEVICE`, named after the SONiC device) plus shared Debian packaging.

```
platform/marvell-prestera/
sonic-platform-marvell/
│
├─ DEVICE/                         -- per-board platform support (SONiC device name)
│   ├── scripts/
│   │   └── DEVICE-init.sh         -- boot-time platform setup (MAC, profile, etc.)
│   ├── service/
│   │   └── DEVICE-init.service    -- systemd unit for the init script
│   ├── setup.py                   -- installs the sonic_platform Python package
│   ├── sonic_platform/            -- SONiC Platform Base API implementation
│   │   ├── chassis.py             -- chassis, ports, and inventory
│   │   ├── component.py           -- firmware components (BIOS, CPLD, FPGA, …)
│   │   ├── eeprom.py              -- system EEPROM (serial, base MAC, TLV)
│   │   ├── __init__.py
│   │   ├── platform.py            -- platform entry point
│   │   ├── sfp_event.py           -- SFP plug/unplug event handling
│   │   ├── sfp.py                 -- transceiver monitoring and control
│   │   ├── utils.py               -- shared platform helpers
│   │   └── watchdog.py            -- hardware watchdog access
│   └── utils/
│       └── get-base-mac.py        -- utility to read base MAC from platform
│
└─ debian/                         -- shared .deb packaging for all boards
    ├── changelog
    ├── compat
    ├── control                    -- package metadata and dependencies
    ├── rules                      -- build rules
    ├── sonic-platform-DEVICE.install   -- files installed into the image
    └── sonic-platform-DEVICE.postinst  -- post-install (enable service, depmod, …)
```

| Path | Description |
|------|-------------|
| `DEVICE/` | Board-specific platform code; one directory per supported SONiC device (e.g. `rd98dx35xx_cn9131`, `db98cx8580-32cd`). |
| `DEVICE/scripts/` | Shell scripts for one-time or boot-time platform initialisation. |
| `DEVICE/service/` | systemd service definitions that run the init scripts. |
| `DEVICE/sonic_platform/` | Python modules implementing the SONiC Platform Base API for monitoring and control. |
| `DEVICE/utils/` | Standalone host utilities used by SONiC or packaging. |
| `debian/` | Debian source metadata used to build per-board `sonic-platform-DEVICE` packages. |

## Target

The target is per-device (for the specified ARCH).

For example:

```
target/debs/trixie/sonic-platform-rd98dx35xx_1.0_arm64.deb
```

The `DEVICE` `.deb` target includes all Python code and scripts from the tree (see the tree template above), and also the `mvcpss.ko` module built for that device.
