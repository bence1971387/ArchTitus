#!/usr/bin/env bash

SCRIPT_DIR="$( cd -- "$(dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

timedatectl set-ntp true
pacman -S --noconfirm pacman-contrib terminus-font
setfont ter-v22b
sed -i 's/^#Para/Para/' /etc/pacman.conf
pacman -S --noconfirm reflector grub rsync
reflector -c Hungary -a 6 --sort rate --save /etc/pacman.d/mirrorlist

echo "Enter disk (example /dev/sda)"
read DISK

sgdisk -Z ${DISK}
sgdisk -a 2048 -o ${DISK}

sgdisk -n 1::+100M --typecode=1:ef00 --change-name=1:'EFIBOOT' ${DISK}
sgdisk -n 2::-0 --typecode=2:8300 --change-name=2:'ROOT' ${DISK}

mkfs.vfat -F32 -n "EFIBOOT" "${DISK}1"
mkfs.ext4 -L "ROOT" "${DISK}2"
mount -t ext4 "${DISK}2" /mnt

pacstrap /mnt base base-devel linux linux-firmware vim sudo archlinux-keyring wget libnewt --noconfirm --needed
genfstab -U /mnt >> /mnt/etc/fstab

cp -R ${SCRIPT_DIR} /mnt/root/ArchTitus

mkdir /mnt/boot
mkdir /mnt/boot/efi
mount -t vfat -L EFIBOOT /mnt/boot/efi

#grub-install --target=x86_64-efi --bootloader-id=GRUB --efi-directory=/mnt/boot/efi
#grub-mkconfig -o /mnt/boot/grub/grub.cfg

mkdir /mnt/opt/swap
dd if=/dev/zero of=/mnt/opt/swap/swapfile bs=1M count=4096 status=progress
chmod 600 /mnt/opt/swap/swapfile
chown root /mnt/opt/swap/swapfile
mkswap /mnt/opt/swap/swapfile
swapon /mnt/opt/swap/swapfile
