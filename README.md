# [S103 · Machine installation project](http://www.lri.fr/~zema/S103/S103.html)

## Version [Arch GNU/Linux](http://archlinux.org/)

### Ash MERIENNE, Alain SANDOZ, Naomie FAZER

## Table of contents

- [Table of contents](#table-of-contents)
- [Arch GNU/Linux installation](#arch-gnulinux-installation)
	- [Disk partitioning and formatting](#disk-partitioning-and-formatting)
	- [File system download and extraction](#file-system-download-and-extraction)
	- [Unmounting](#unmounting)
 	- [Reboot and keys initializing](#reboot-and-keys-initializing)
  	- [Some packages to install](#some-packages-to-install)

## Arch GNU/Linux installation

- Sources
	- [Raspberry Pi 4](https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4)
	- [Raspberry Pi 3](https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3)

**Disclaimer: the following text is the same from the sources above with slight twists, and is not of my creation.**

### Disk partitioning and formatting

- Connect to the internet

		ip link
		ping archlinux.org

- Partition the disk (SD)

		fdisk -l
		disk /dev/sdX

	- Erase existing partitions, create the boot partition, set it to W95 FAT32

			o n p 1 ENTER 200M t c

	- Create root partition on the remaining space on the disk

			n p 2 ENTER ENTER

- Partition formatting and mounting
	- Format *boot* partition in *W95 FAT32*

			mkfs.vfat /dev/sdX1

	- Create and mount FAT filesystem

			mkdir boot
			mount /dev/sdX1 boot

	- Format *root* partition in *ext4*

			mkfs.ext4 /dev/sdX2

	- Create and mount the ext4 filesystem

			mkdir root
			mount /dev/sdX2 root

### File system download and extraction

**Warning: run these commands as root, not via sudo**

Choose the tarball to install:
- For ARMv7 (recommanded)

	http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-armv7-latest.tar.gz

- For AArch64

	http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz

<br>

	wget [tarball choisi]
	bsdtar -xpf [archive téléchargée] -C root
	sync

### Unmounting

- Move boot files on first partition

		mv root/boot/* boot

- Unmount partitions

		umount boot root

	For Raspberry Pi 4 only, update fstab for SD block:

		sed -i 's/mmcblk0/mmcblk1/g' root/etc/fstab

### Reboot and keys initializing

**Note: do this on the Raspberry Pi**

- Insert SD card
- Connect ethernet cable
- Power the card
- Login on the card (via Console/SSH)
	- Login as default user *alarm* with password *alarm*.
    	- Default *root* password is *root*

- Change keyboard layout

		loadkeys fr-latin1

- Activate internet services

		systemctl systemd-networkd.service
    
- Initialize and populate Arch with keys

		pacman-key --init
		pacman-key --populate archlinuxarm

### Some packages to install

- Gnome & Wayland

		sudo pacman -Syu gnome gnome-extra wayland

	Enable gdm services for startup launch

  		systemctl enable gdm.service

- Git & GitAhead

		sudo pacman -Syu git gitahead

- Sublime Text & Nano

  		sudo pacman -Syu nano sublime-text-4

- Bat

  		sudo pacman -Syu bat

<br><br>

[Return to top](#table-of-content)
