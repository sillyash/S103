# [S103 · Machine installation project](http://www.lri.fr/~zema/S103/S103.html)

## By Naomie FAZER, Ash MERIENNE and Alain SANDOZ

### Paris-Saclay University | 23/01/2024


## Table of contents

- [Table of contents](#table-of-contents)
- [Arch GNU/Linux installation](#arch-gnulinux-installation)
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
	- [Create tables and insert data into the tables](#create-tables-and-insert-data-into-the-tables)
- [Setup users](#setup-users)
- [Difficulties encountered](#difficulties-encountered)


## Arch GNU/Linux installation

**This section was moved to another [file](https://github.com/sillyash/S103/blob/e946c84e2755f63c79eac0104a4ad5e2d70f530a/README.md#raspberry-pi-os-installation)**
 
## Problems

**Xserver did not work on the installation, and we didn't find any documebtation concerning our error. "startx" returned an error exit status.**

**We wanted to have a GUI for our system, so we gave up on Arch ARM and restarted from scratch with Raspberry OS...**

## Raspberry Pi OS installation

### Flashing the SD card

	sudo rpi-imager

 Choose Raspberry Pi OS 64-bits
 
 **In the options:**
 
 choose ```enable SSH```, set ```locale fr```, user ```student``` and set password to ```pwdstudent```.


### First boot and setting up

Plug the SD card in the Raspberry Pi, power the card and boot up.


### Language and keyboard settings

- Language (Settings -> Raspberry Pi Configuration -> Localisation)
	- set locale to ```fr```
	- set keyboard to ```fr```
	- set language to ```fr```
	- set country to ```fr```
	- set character set to ```UTF-8```
- Timezone and keyboard
	- set time zone to ```Europe/Paris```
	- change keyboard layout to ```french - France```


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

To access the MariaDB CLI, we use:

	sudo mysql


### Root user creation

To create our first user (root), we use:

	sudo mysql_secure_installation

Next, press ```ENTER``` to  enter the password for ```root``` (currently, there is none, that's why we press ```ENTER```).

Press ```Y``` to switch to unix_socket authentication, then ```Y``` again to set a new password for ```root```. \
Set the password to ```"root"```.

Press ```N``` to not disallow remote root connection to the database.

Press ```Y``` three times until the setup is complete. \
Now, MariaDB is ready to use with root login.


### Connect to the MariaDB server

Use this command to connect to the server. \
```-u``` specifies the user, so we put ```-uroot``` to connect as user ```root```. \
```-p``` specifies the password, so we put ```-proot``` for the password.

	mysql -uroot -proot

The same command, but with more verbose:

	mysql --user=root --password=root


## Create the database and data

### Create the database

To create the database and use this database, we use the following MySQL command:

	CREATE DATABASE CAMPING;
	USE CAMPING;

And MariaDB should show that you're in the database like so:

	MariaDB[CAMPING]>

Next time you log in MariaDB, to gain time, you should use:

	mysql -uroot -proot -p CAMPING


### Create tables and insert data into the tables

To create the tables, we simply use MySQL, like so:

	CREATE TABLE ... (...);

To fill the tables with data, we simply use MySQL, like so:

	INSERT INTO ... VALUES(...);

We made scripts in advance so we could just create everything in a single command: \
[Tables creation](https://github.com/sillyash/S103/blob/1c3209d38636e17decee25541b95f67d224a5574/tables.sql) - 
[Data insertion](https://github.com/sillyash/S103/blob/main/data.sql) \
Download the scripts in the personal repository.

To execute the scripts, we used:

	source ~/tables.sql
	source ~/data.sql


## Setup users

First we need to modify the ```bind_address``` attribute for our server, to allow any IP to connect to it.

    cd /etc/MySQL/mariadb.conf.d
    sudo nano 50-server.cnf

And find the line beginning by ```bind_address``` and change the address to ```0.0.0.0```.

To create a new user, after logging in to MariaDB and allow the user to do anything on the database:

	CREATE USER 'prof'@'10.42.0.1' IDENTIFIED BY 'pwdprof';
	GRANT ALL PRIVILEGES ON CAMPING.* TO 'prof'@'10.42.0.1';

Reboot the Raspberry Pi.

Finally, create a text file in your personal directory containing the name of your group's students.

    touch students.txt
    nano students.txt

## Difficulties encountered

We wasted 3 hours installing Arch only to realize we wouldn't have a GUI and a guarantee that SSH would work.

First of all, ther's been an overall confusion about the ```hostname``` for the ```prof``` user.
There's been a mix-up between '10.42.0.2', '%', and finally, the one that worked out: '10.42.0.1'.

Also, we had a hard time finding the problem about the ```bind_address``` problem: we found some documentation online and got helped by another group concerning this issue.

## Task dispatching

- Alain SANDOZ
	- SQL scripts
 	- Finding help online (chatbots, forums...)
- Naomie FAZER
 	- Most of the commands that we ran
  	- The first and end part of the report
  	- Documentation gathering
- Ash MERIENNE
  	- Some commands
   	- The rest of the report (including [ARCH-README](./ARCH-README.md))
