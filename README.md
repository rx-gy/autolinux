# Autolinux - reduce time spent **re**building

![Logo](/splash.png)

## Status - V0.1 - incomplete/unstable

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



### preseed.cfg
Needs lots of work - barely readable. Everything excluding volume partitioning to be automated. Ideally no desktop environment. The desktop setup should be installed and managed in ansible.

> [!CAUTION]
> Still builds the desktop environment

### mini.iso
TODO: fix the grub text - currently barely readable on white image.



### Pre-requisites and iso sources
```
wget https://d-i.debian.org/daily-images/amd64/daily/netboot/mini.iso
sudo apt install p7zip-full p7zip-rar genisoimage fakeroot xorriso isolinux binutils squashfs-tools
```


## Useful
To get the details of *this* debian machine
```
sudo debconf-get-selections --installer >> local-preseed.txt
```

## Process notes
Based on debian [sid](https://wiki.debian.org/DebianUnstable). Dev machine is debian bookworm host.

## References
* [1] https://wiki.debian.org/RepackBootableISO

