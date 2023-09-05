#!/bin/sh
# Simple script to make the partitions on a fresh install
# Author: aaaaluki

# -e: exit if a command fails
# -u: write to stderr if trying to expand unset parameter
# -x: write to stderr a trace of each executed command
set -eux

# Constants
DEVICE="/dev/sda"
VG_NAME="Larkin"

BOOT_LABEL="EFI"
SWAP_LABEL="swap"
LVM2_LABEL="volume_rh"

BOOT_SIZE="512M"
SWAP_SIZE="20G"
ROOT_SIZE="128G"

get_partition_name() {
    part=$(lsblk "${1}" -r -o NAME,PATH,PARTLABEL | \
           grep -E "${DEVICE}[0-9]+ +${2}" | \
           tr -s " " | \
           cut -d " " -f 2)
    printf "%s" "${part}"
}

# Create a new empty GUID Partition Table (GPT)
sgdisk "${DEVICE}" -o

# Create boot partition
sgdisk "${DEVICE}" -n "0:0:+${BOOT_SIZE}" -t 0:EF00 -c 0:"${BOOT_LABEL}"

# Create swap partition
sgdisk "${DEVICE}" -n "0:0:+${SWAP_SIZE}" -t 0:8200 -c 0:"${SWAP_LABEL}"

# Create root+home volume partition
sgdisk "${DEVICE}" -n 0:0:0 -t 0:8E00 -c 0:"${LVM2_LABEL}"

# Display results
sgdisk "${DEVICE}" -p

## Get paths to each partition
## NOTE: A small sleep might be needed, if not the first partition might not
## be read correctly
sleep 1

boot_part=$(get_partition_name "${DEVICE}" "${BOOT_LABEL}")
swap_part=$(get_partition_name "${DEVICE}" "${SWAP_LABEL}")
lvm2_part=$(get_partition_name "${DEVICE}" "${LVM2_LABEL}")

# Create LVM2 for root (/) and home
pvcreate "${lvm2_part}"
vgcreate "${VG_NAME}" "${lvm2_part}"

lvcreate -L "${ROOT_SIZE}" "${VG_NAME}" -n lvolroot
lvcreate -l 100%FREE "${VG_NAME}" -n lvolhome
lvreduce -f -L -256M "${VG_NAME}/lvolhome"

root_part="/dev/${VG_NAME}/lvolroot"
home_part="/dev/${VG_NAME}/lvolhome"

# Format partitions
mkfs.fat -F32 "${boot_part}"
mkswap "${swap_part}"
mkfs.ext4 "${root_part}"
mkfs.ext4 "${home_part}"

# Mount partitions
mount "${root_part}" /mnt
mount --mkdir "${boot_part}" /mnt/boot
swapon "${swap_part}"
mount --mkdir "${home_part}" /mnt/home

