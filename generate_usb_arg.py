#!/usr/bin/env python3

import subprocess


try:
    result = ""
    res = subprocess.check_output('lsusb').decode('utf-8')
    line = res.split('\n')
    usb_strs = [l for l in line if 'ID 1e10:4000' in l]
    for usb_str in usb_strs:
        usb_bus = usb_str.split()[1]
        usb_port = usb_str.split()[3].rstrip(":")
        result += "-v /dev/bus/usb/" + usb_bus + "/" + usb_port + \
                ":/dev/bus/usb/" + usb_bus + "/" + usb_port + " "

    print(result)

except:
    print("error getting lsusb")
