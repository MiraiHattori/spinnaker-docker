#!/usr/bin/env python3

import subprocess
import re

try:
    res = subprocess.check_output('lsusb').decode('utf-8')
    line = res.split('\n')
    usb_strs = [l for l in line if 'ID 1e10:4000' in l]
    for usb_str in usb_strs:
        usb_bus = usb_str.split()[1]
        usb_port = usb_str.split()[3].rstrip(":")
        cmd = 'udevadm info --query=path --name=/dev/bus/usb/' + usb_bus + '/' + usb_port
        res = subprocess.check_output(cmd.split()).decode('utf-8')
        target_usb = re.search(r"/([0-9]+-[0-9]+\.[0-9]+)$", res).group().lstrip('/').rstrip('\n')
        print("plug out usb {}".format(target_usb))
        with open('/sys/bus/usb/drivers/usb/unbind', 'w') as f:
            f.write(target_usb.rstrip('\n'))
        print("plug in usb {}".format(target_usb))
        with open('/sys/bus/usb/drivers/usb/bind', 'w') as f:
            f.write(target_usb.rstrip('\n'))
except Exception as e:
    print("Error repluging usb: {}".format(e))
