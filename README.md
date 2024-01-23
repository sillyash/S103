# [S103 · Machine installation project](http://www.lri.fr/~zema/S103/S103.html)

### By Naomie FAZER, Ash MERIENNE and Alain SANDOZ


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
	- [Create tables](#create-tables)
	- [Insert data into the tables](#insert-data-into-the-tables)
- [Setup users](#setup-users)



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
	- set time zone to europe Paris in settings or do:

			timedatectl set-timezone "Europe/Paris"
		This should change the timezone to ```UTC+1```

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

To access the MariaDB commmand line and database, we use (the first time at least):

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

	CREATE DATABASE CAMPING;

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
[See script](https://github.com/sillyash/S103/blob/1c3209d38636e17decee25541b95f67d224a5574/tables.sql) (we had to download the scripts in the personal repository)

To execute the script, we used:

	source ~/tables.sql

In the MariaDB terminal.


### Insert data into the tables

To fill the tables with data, we simply use MySQL, like so:

	INSERT INTO ... VALUES(X, X, X, X);
	INSERT INTO ... VALUES(X, X, X, X);
	...

We also used a script to gain some time for this. \
[See script](https://github.com/sillyash/S103/blob/main/data.sql)

To execute the script, we used:

	source ~/data.sql

In the MariaDB terminal.


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

First we need to modify the ```bind_address``` attribute for our server, to allow any IP to connect to it.

    cd /etc/MySQL/mariadb.conf.d
    sudo nano 50-server.cnf

And find the line beginning by ```bind_address``` and change the address to ```0.0.0.0```.

Which means we need to create a user with the specified name and password. \
Using the previous commands, we can do:

	CREATE USER 'prof'@'10.42.0.1' IDENTIFIED BY 'pwdprof';
	GRANT ALL PRIVILEGES ON CAMPING.* TO 'prof'@'10.42.0.1';

The ```%``` allow the remote user to connect from any IP using this login.

To check the connection:

	   sudo mysql -uprof -p CAMPING
    SELECT user(), current_user();


It should return something like:

    prof@localhost | prof@10.42.0.1

Finally, create a text file in your personal directory containing the name of your group's students.

    touch students.txt
    nano students.txt


<br><br>

[Return to top](#table-of-contents)
