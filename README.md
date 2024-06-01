# Autolinux - reduce time spent **re**building

![Logo](/splash.png)

> [!CAUTION]
> This is built for my system and may break yours or worse. It will overwrite your disk during install, and doesn't give you a chance to confirm it is the correct disk.

## Status - V0.2 - incomplete/unstable
- [x] basic maintenance processes scripted
- [x] bootable preseeded iso 
- [x] preseed deployment concise and maintainable
- [x] ansible-pull bootstrap from iso
- [ ] ansible-pull for live system updates

## Ansible wishlist
- [ ] i3wm with specific settings
- [ ] oh-my-zsh and powerlevel10k
- [ ] syncthing
- [ ] grub splash 


**TASKS**
* Embed authorized_keys file into preseed
* Test ansible-pull bootstrap
> [!NOTE]
> Asks for confirmation of partitioning - it isn't meant to.
> It is not doing boot stuff as expected - boots, but is doing odd efi things to other disks. *beware*

Only asks for confirmation of partitioning - although it isn't meant to. 


## Problem
I want my current linux build to be documented and reproducible such that a complete rebuild, or a partial reacreation is not a time consuming trial and error effort.

## Overall approach
This is essentially a configuration management and automated deployment problem.

The base linux is debian and aimed at sid. The configuration management and automation is handled by ansible-pull with git providing versioning. The bare metal component is built on a debian preseed that bootstraps the initial ansible pull for a _from scratch_ build. 

Currently ansible pull is being added as a one-shot service that is run at boot time. The system will not have the ansible components installed until after the first boot has occured.

This git repo contains the intstructions everything for building and maintaining my linux environments - at some point the ansible playbooks will likely be separated.

## Principles
1. A rebuild needs to be reasonably hands off.
2. Updating the config needs to be straight forward - ideally live system changes are implemented first in the ansible config and then deployed from there.
3. Where 2. is impractical add a specific note/script documenting the system change so it's at least captured for later reference.


## Specifics
Develop a preseed file to describe the base configuration, then playbooks to build out the rest. Develop scripts to automate the updating and embedding of the preseed into an iso. Use [ventoy](https://ventoy.net/en/index.html) on a bootable USB to deploy base image.


# autolinux - mechanised
## preseed.cfg
Reasonably terse and readable preseed. I’m not sure I’m happy with the partitioning and grub installation. I suspect using LVM is the problem. 

## mini.iso
TODO: fix the grub text - currently barely readable on white image.
> [!NOTE]
> The installer only works while the kernel is relatively synchronised with the sid repos. This means you shouldn't assume an installer built now will work in a month.

## build_iso.sh
This script builds an iso somewhat manually. Makes a whole bunch of assuptions about source and folders etc. (See [References](/README.md#references))

## update_preseed.sh
This script is intended to enable rapid updating of the iso after a change to the preseed has been made.

## Pre-requisites and iso sources
```
wget https://d-i.debian.org/daily-images/amd64/daily/netboot/mini.iso
sudo apt install p7zip-full p7zip-rar genisoimage fakeroot xorriso isolinux binutils squashfs-tools
```
> [!NOTE]
> Run against debian bookworm


## Useful
To get the details of *this* debian machine
```
sudo debconf-get-selections --installer >> local-preseed.txt
```

## Process notes
Based on debian [sid](https://wiki.debian.org/DebianUnstable). Dev machine is debian bookworm host.

## References
* Repacking iso images - [debian doco](https://wiki.debian.org/RepackBootableISO)
* Preseed [basics](https://wiki.debian.org/DebianInstaller/Preseed)
* Preseed in massive [detail](https://preseed.debian.net/debian-preseed/sid/amd64-main-full.txt)
* Possibly usefully concise preseed [examples](https://dev1galaxy.org/viewtopic.php?id=1853)
* Scripted ubuntu preseed generator [repo](https://github.com/covertsh/ubuntu-autoinstall-generator)
