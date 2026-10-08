#!/bin/bash

# Platform init script for db98dx73xx-cn9131

db98dx73xx-cn9131_profile()
{
    MAC_ADDR=$(fw_printenv -n ethaddr)
    find /usr/share/sonic/device/*db98DX73xx_cn9131* -name profile.ini | xargs sed -i "s/switchMacAddress=.*/switchMacAddress=$MAC_ADDR/g"
    echo "db98dx73xx_cn9131: Updating switch mac address ${MAC_ADDR}"
}

# - Main entry
db98dx73xx-cn9131_profile

# Dummy platform.json to eliminate "systemd-sonic-generator: Failed to open"
echo "{ }" > /usr/share/sonic/device/arm64-marvell_db98DX73xx_cn9131-r0/platform.json

exit 0
