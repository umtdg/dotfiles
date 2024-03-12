#!/usr/bin/env python3

import argparse
import cmd
import fcntl
import os
import pathlib
import pydbus
import sys
import tempfile

from subprocess import run, CalledProcessError

BLUE="%{F#5E81AC}"
RED="%{F#BF616A}"
ORANGE="%{F#D08770}"

BT_ICON = ""
BATTERY_MAP = {
    10: "󰤾",
    20: "󰤿",
    30: "󰥀",
    40: "󰥁",
    50: "󰥂",
    60: "󰥃",
    70: "󰥄",
    80: "󰥅",
    90: "󰥆",
    100: "󰥈"
}

DBUS_BLUEZ = "org.bluez"
DBUS_BLUEZ_DEV1 = "org.bluez.Device1"
DBUS_BLUEZ_BAT1 = "org.bluez.Battery1"
DBUS_BLUEZ_ADAPTER = "/org/bluez/hci0"

POLYBAR_CFG = pathlib.Path.home() / ".config" / "polybar"
if POLYBAR_CFG.is_symlink():
    POLYBAR_CFG = pathlib.Path(POLYBAR_CFG.resolve())
DEV_FILE = POLYBAR_CFG / ".bt"

ROFI = pathlib.Path.home() / ".config" / "rofi" / "bin" / "rofi_colorful"
ROFI_ARGS = [
    str(ROFI), "-dmenu",
    "-p", "Please select Bluetooth device to display"
]


class BluetoothDevice():
    def __init__(self, name: str, battery: int):
        self.name = name
        self.battery = battery

    def __str__(self) -> str:
        if self.battery > 0:
            return f"{BATTERY_MAP[self.battery]} {self.name} ({self.battery}%)"
        else:
            return self.name


def get_bluez_dbus():
    bus = pydbus.SystemBus()
    adapter = bus.get(DBUS_BLUEZ, DBUS_BLUEZ_ADAPTER)
    manager = bus.get(DBUS_BLUEZ, "/")

    return bus, adapter, manager


def get_connected_devices() -> list:
    _, _, manager = get_bluez_dbus()

    bt_devices = []
    managed_objs = manager.GetManagedObjects()
    for path in managed_objs:
        dev = managed_objs[path].get(DBUS_BLUEZ_DEV1, {})
        connected = dev.get("Connected", False)

        if not connected: continue

        bat = managed_objs[path].get(DBUS_BLUEZ_BAT1, {})

        name = dev.get("Name", "Unknown")
        battery = bat.get("Percentage", 0)
        bt_devices.append(BluetoothDevice(name, battery))

    return bt_devices


def set_name_of_device_to_show(dev_to_show) -> None:
    DEV_FILE.touch(exist_ok=True)
    with DEV_FILE.open("w") as f:
        fcntl.flock(f, fcntl.LOCK_EX)
        try:
            f.write(f"{dev_to_show}\n")
        finally:
            fcntl.flock(f, fcntl.LOCK_UN)


def get_name_of_device_to_show(dev_list) -> str:
    dev_to_show = ""

    DEV_FILE.touch(exist_ok=True)
    with DEV_FILE.open("r") as f:
        dev_to_show = f.readline().strip()

    if dev_to_show == "":
        dev_to_show = dev_list[0].name

    set_name_of_device_to_show(dev_to_show)

    return dev_to_show


def toggle_bluetooth() -> None:
    _, adapter, _ = get_bluez_dbus()
    adapter.Powered = not adapter.Powered


def print_selected(devices: list) -> None:
    _, adapter, _ = get_bluez_dbus()
    dev_name = get_name_of_device_to_show(devices)

    if not adapter.Powered:
        if sys.stdout.isatty():
            print(f"Powered off")
        else:
            print(f"{RED}{BT_ICON} {dev_name}")
        return

    for dev in devices:
        if dev.name != dev_name: continue

        if sys.stdout.isatty():
            print(f"{dev}")
        else:
            print(f"{BLUE}{BT_ICON} {dev}")
        return

    if sys.stdout.isatty():
        print(f"Device to display is not connected")
    else:
        print(f"{ORANGE}{BT_ICON} {dev_name}")


def select_dev_to_show(devices) -> None:
    tmp_name = ""
    with tempfile.NamedTemporaryFile(delete=False) as tmp:
        tmp_name = tmp.name
        for dev in devices:
            tmp.write(f"{dev.name}\n".encode("utf-8"))

    try:
        with open(tmp_name, "r") as tmp:
            p = run(ROFI_ARGS, stdin=tmp, capture_output=True, check=True)
    except CalledProcessError:
        if sys.stdout.isatty():
            print("No device selected")
        exit(1)
    except Exception:
        if sys.stdout.isatty():
            print("Errors occured with device selection dialog")
        exit(1)
    finally:
        os.remove(tmp_name)

    set_name_of_device_to_show(p.stdout.decode("utf-8"))


class BluetoothCmd(cmd.Cmd):
    def do_display(self, arg):
        devices = get_connected_devices()
        print_selected(devices)

    def do_select(self, arg):
        devices = get_connected_devices()
        select_dev_to_show(devices)

    def do_toggle(self, arg):
        toggle_bluetooth()


def main():
    BluetoothCmd().onecmd("".join(sys.argv[1:]))


if __name__ == "__main__":
    main()

