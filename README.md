# [S103 · Installation d'un poste pour le développement](http://www.lri.fr/~zema/S103/S103.html)

## Version [Arch GNU/Linux](http://archlinux.org/)

### Ash MERIENNE, Alain SANDOZ, Naomie FAZER

## Sommaire

- [Sommaire](#sommaire)
- [Matériel](#matériel)
- [Installation de Arch GNU/Linux](#installation-de-arch-gnulinux)
	- [Installation du système](#installation-du-système)
	- [Téléchargement et extraction du système de fichiers root](#téléchargement-et-extraction-du-système-de-fichiers-root)
	- [Démontage des partitions](#démontage-des-partitions)
 	- [Reboot et remplissage des clés](#reboot-et-remplissage-des-clés)

## Matériel

- 1 Raspberry Pi 400
- 1 Carte SD
- 1 Lecteur/adaptateur de carte SD
- 1 Adaptateur Ethernet-to-USB
- 1 Patch UTP (petit câble Ethernet)
- 1 Câble HDMI-to-miniHDMI (pour connecter la carte à un écran)
- 1 Câble USBa-to-USBc (pour alimenter la carte) 

## Installation de Arch GNU/Linux

- Sources
	- [Raspberry Pi 4](https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-4)
	- [Raspberry Pi 3](https://archlinuxarm.org/platforms/armv8/broadcom/raspberry-pi-3)

**Attention: Toutes les étapes suivantes (sauf précision du contraire) sont à effectuer sur ordinateur.**

### Installation du système

- Connexion à internet

		ip link
		ping archlinux.org

- Partitionner le disque (SD)

		fdisk -l
		disk /dev/sdX

	- Effacer les partitions préexistantes, créer la partition boot, la mettre en W95 FAT32

			o n p 1 ENTER 200M t c

	- Créer la partition root sur le reste du disque

			n p 2 ENTER ENTER

- Formatage des partitions et mn,tage des systèmes de fichiers
	- Formater la partition *boot* en *W95 FAT32*

			mkfs.vfat /dev/sdX1

	- Créer et monter le système boot

			mkdir boot
			mount /dev/sdX1 boot

	- Formater la partition *root* en *ext4*

			mkfs.ext4 /dev/sdX2

	- Créer et monter le système root

			mkdir root
			mount /dev/sdX2 root

### Téléchargement et extraction du système de fichiers root

**Attention: à effectuer en tant que root, pas via sudo**

Choisir le tarball à installer:
- Pour ARMv7 (recommandé)

	http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-armv7-latest.tar.gz

- Pour AArch64

	http://os.archlinuxarm.org/os/ArchLinuxARM-rpi-aarch64-latest.tar.gz

<br>

	wget [tarball choisi]
	bsdtar -xpf [archive téléchargée] -C root
	sync

### Démontage des partitions

- Déplacer les fichiers boot sur la première partition

		mv root/boot/* boot

- Démonter les partitions

		umount boot root

	Pour Raspberry Pi 4 seulement, mettre à jour fstab pour le bloc SD:

		sed -i 's/mmcblk0/mmcblk1/g' root/etc/fstab

### Reboot et remplissage des clés

**Attention: Cette partie s'effectue sur Raspberry Pi**

- Insérer la carte SD dans la carte
- Connecter la câble Ethernet
- Alimenter la carte
- Login sur la carte (via Console/SSH)

		loadkeys fr-latin1
    
	- Login en tant que utilisateur par défaut *alarm* avec le mot de passe *alarm*.
    - Le mot de passe *root* par défaut est *root*
- Initialisation et remplissage des clés

		pacman-key --init
		pacman-key --populate archlinuxarm

### Quelques paquets à installer

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

[Retour au sommaire](#sommaire)
