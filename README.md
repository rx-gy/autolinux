# Autolinux - reduce time spent **re**building

![Logo](/splash.png)

## Status - V0.1 - incomplete/unstable
- [x] basic maintenance processes scripted
- [x] bootable preseeded iso 
- [ ] preseed deployment concise and maintainable
- [ ] ansible-pull bootstrap from iso
- [ ] ansible-pull for live system updates

**TASKS**
* Cull preseed back to headings[^preseed-ex]
* Embed authorized_keys file into preseed
* Test ansible-pull bootstrap

## Problem
I want my current linux build to be documented and reproducible such that a complete rebuild, or a partial reacreation is not a time consuming trial and error effort.

## Overall approach
This is essentially a configuration management and automated deploment problem.

The base linux is debian and aimed at sid. The configuration management and automation is handled by ansible-pull with git providing versioning. The bare metal component is built on a debian preseed that bootstraps the initial ansible pull for a _from scratch_ build. 

This git repo contains the intstructions everything for building and maintaining my linux environments - at some point the ansible playbooks will likely be separated.

## Principles
1. A rebuild needs to be reasonably hands off.
2. Updating the config needs to be straight forward - ideally live system changes are implemented first in the ansible config and then deployed from there.
3. Where 2. is impractical add a specific note/script documenting the system change so it's at least captured for later reference.


## Specifics
Develop a preseed file to describe the base configuration, then playbooks to build out the rest. Develop scripts to automate the updating and embedding of the preseed into an iso. Use [ventoy](https://ventoy.net/en/index.html) on a bootable USB to deploy base image.


# autolinux - mechanised
## preseed.cfg
Needs lots of work - barely readable. Everything excluding volume partitioning to be automated. Ideally no desktop environment. The desktop setup should be installed and managed in ansible.

> [!CAUTION]
> Still builds the desktop environment

## mini.iso
TODO: fix the grub text - currently barely readable on white image.

## build_iso.sh
This script builds an iso somewhat manually. Makes a whole bunch of assuptions about source and folders etc. (See [[#References]])

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

[^iso-repack]: Repacking iso images - [debian doco](https://wiki.debian.org/RepackBootableISO)
[^preseed-basic]: Preseed [basics](https://wiki.debian.org/DebianInstaller/Preseed)
[^preseed-detail]: Preseed in massive [detail](https://preseed.debian.net/debian-preseed/sid/amd64-main-full.txt)
[^preseed-ex]: Possibly usefully concise preseed [examples](https://dev1galaxy.org/viewtopic.php?id=1853)
