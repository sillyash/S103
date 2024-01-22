# [S103 · Machine installation project](http://www.lri.fr/~zema/S103/S103.html)

### By Naomie FAZER, Ash MERIENNE and Alain SANDOZ


## Table of contents

- [Table of contents](#table-of-contents)
- [Arch GNU/Linux installation](#arch-gnulinux-installation)
	- [Disk partitioning and formatting](#disk-partitioning-and-formatting)
	- [File system download and extraction](#file-system-download-and-extraction)
	- [Unmounting](#unmounting)
 	- [Reboot and keys initializing](#reboot-and-keys-initializing)
  	- [Some packages to install](#some-packages-to-install)
- [Problems](#problems)
- [Raspberry Pi OS installation](#raspberry-pi-os-installation)
	- [Flashing the SD card](#flashing-the-sd-card)
	- [First boot and setting up](#first-boot-and-setting-up)
	- [Language and keyboard settings](#language-and-keyboard-settings)
	- [Network setup](#network-setup)
- [MariaDB installation](#mariadb-installation)
	- [Update package list](#update-package-list)
	- [Install MariaDB server](#install-mariadb-server)
- [MariaDB setup](#mariadb-setup)
	- [Accessing the database](#accessing-the-database)
	- [Root user creation](#root-user-creation)
	- [Connect to the MariaDB server](#connect-to-the-mariadb-server)
	- [A few basics](#a-few-basics)
- [Create the database and data](#create-the-database-and-data)
	- [Create the database](#create-the-database)
	- [Create tables](#create-tables)
	- [Insert data into the tables](#insert-data-into-the-tables)
- [Setup users](#setup-users)



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

- Update and install packages for the system
  
		pacman -Syu


### Some packages to install

- LXDE & Xserver (GUI)

		pacman -S xorg xinit lxde

- MariaDB server

  		pacman -S mariadb-server
 
## Problems

**Xserver did not work on the installation, and we didn't find any documebtation concerning our error. "startx" returned an error exit status.**

**We wanted to have a GUI for our system, so we gave up on Arch ARM and restarted from scratch with Raspberry OS...**

## Raspberry Pi OS installation

### Flashing the SD card

	sudo rpi-imager

 Choose Raspberry Pi OS 64-bits
 
 **In the options:**
 
 choose ```enable SSH```, set ```lang fr```, user ```pi``` and set password to ```student```.


### First boot and setting up

Plug the SD card in the Raspberry Pi, power the card and boot up.


### Language and keyboard settings

- Language (Settings -> Language)
	- set locale to ```fr```
	- set keyboard to ```fr```
	- set language to ```fr```
	- set country to ```fr```
	- set character set to ```UTF-8```
- Timezone and keyboard
	- set time zone to europe Paris

			timedatectl set-timezone "Europe/Paris"
		This should change the timezone to ```UTC+1```

	- change keyboard layout to ```french - France``` (Settings -> Language)


### Network setup

Manually set the time and date of the Raspberry Pi.

	sudo date -s "YYYY-MM-DD HH:MM:SS"

Normally, if you haven't tried connecting to WLAN or modified the properties of ```eth0```, internet should work fine.


## MariaDB installation

Resources used: https://raspberrytips.com/install-mariadb-raspberry-pi/


### Update package list

	sudo apt-get update [--fix-missing] (if problems with next step)
	sudo apt upgrade


### Install MariaDB server

	sudo apt install mariadb-server

This command will also install ```MariaDB client``` and ```MySql``` (they're dependencies of this package).


## MariaDB setup

### Accessing the database

To access the MariaDB commmand line and database, we use (the first time at least):

	sudo mysql


### Root user creation

To create our first user (root), we use:

	sudo mysql_secure_installation

Next, press ```ENTER``` to  enter the password for ```root``` (currently, there is none, that's why we press ```ENTER```).

Press ```Y``` to switch to unix_socket authentication, the ```Y``` again to set a new password for ```root```. \
Set the password to ```"root"```.

Press ```Y``` four times until the setup is complete. \
Now, MariaDB is ready to use with root login.


### Connect to the MariaDB server

Use this command to connect to the server. \
```-u``` specifies the user, so we put ```-uroot``` to connect as user ```root```. \
```-p``` specifies the password, so we put ```-proot``` for the password.

	mysql -uroot -proot

The same command, but with more verbose:

	mysql --user=root --password=root


### A few basics

In MariaDB, you cann see the list of commands using ```\h``` for help.\
You can also use any MySQL command, such as ```SHOW DATABASES;``` or ```SHOW TABLES;```...

You can of course use any SQL command such as:

	SELECT * FROM ...
	INSERT INTO ...
	CREATE TABLE ...
	DROP TABLE ...


## Create the database and data

### Create the database

To create the database, we use the following MySQL command:

	CREATE DETABASE CAMPING;

To use this database, we simply do:

	USE CAMPING;

And MariaDB should show that you're in the database like so:

	MariaDB[CAMPING]>

Next time you log in MariaDB, to gain time, you should use:

	mysql -uroot -proot -p CAMPING

To directly login into the the right database.


### Create tables

To create the tables, we simply use MySQL, like so:

	CREATE TABLE X (
		xId INT NOT NULL,
		X   X,
		X	X,
		PRIMARY KEY(xId),
		FOREIGN KEY(X)
	);

We made a script in advance so we could just create everything in a single command. \
[See script](./tables.sql)

### Insert data into the tables

To fill the tables with data, we simply use MySQL, like so:

	INSERT INTO ... VALUES(X, X, X, X);
	INSERT INTO ... VALUES(X, X, X, X);
	...

We also used a script to gain some time for this. \
[See script](./data.sql)


## Setup users

To create a new user, after logging in to MariaDB: \
*(change ```'username'```, ```'localhost'``` and ```'password'``` to the desired username, passwors and host.)*

	CREATE USER 'username'@'localhost' IDENTIFIED BY 'password';

To allow the user to do anything on the database:

	GRANT ALL PRIVILEGES ON CAMPING.* TO 'username'@'localhost';

In the test script on ```lri.fr```, we can see the following lines:

	db_config = {
    'user': 'prof',
    'password': 'pwdprof',
    'host': '10.42.0.2',
    'database': 'CAMPING',
	}

Which means we need to create a user with the specified name and password. \
Using the previous commands, we can do:

	CREATE USER 'prof'@'localhost' IDENTIFIED BY 'pwdprof';
	GRANT ALL PRIVILEGES ON CAMPING.* TO 'prof'@'localhost';

To check the connection:

	sudo mysql -uprof -p voyage


<br><br>

[Return to top](#table-of-contents)
