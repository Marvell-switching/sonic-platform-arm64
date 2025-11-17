#!/bin/bash

# Platform init script for rd98dx35xx-cn9131

rd98dx35xx-cn9131_profile()
{
    MAC_ADDR=$(fw_printenv -n ethaddr)
    find /usr/share/sonic/device/*rd98DX35xx_cn9131* -name profile.ini | xargs sed -i "s/switchMacAddress=.*/switchMacAddress=$MAC_ADDR/g"
    echo "rd98dx35xx_cn9131: Updating switch mac address ${MAC_ADDR}"
}

# - Main entry
rd98dx35xx-cn9131_profile

# Dummy platform.json to eliminate "systemd-sonic-generator: Failed to open"
echo "{ }" > /usr/share/sonic/device/arm64-marvell_rd98DX35xx_cn9131-r0/platform.json

exit 0
