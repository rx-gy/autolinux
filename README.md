# Autolinux - reduce time spent **re**building

![Logo](/splash.png)

> [!WARNING]
> This is built for my system and may break yours or worse. It will overwrite your disk during install, and doesn't give you a chance to confirm it is the correct disk.

## Status - V1.0 - initial release
- [x] basic maintenance processes scripted
- [x] bootable preseeded iso 
- [x] preseed deployment concise and maintainable
- [x] ansible-pull bootstrap from iso
- [x] ansible-pull for live system updates

## Ansible tasks
- [ ] ssh config
- [ ] sshd config
- [x] fonts
- [x] urxvt settings
- [ ] oh-my-zsh and powerlevel10k
- [x] i3wm with basic customisation
- [ ] possible switch to dwm...
- [ ] syncthing
- [ ] grub splash 

## Problem
I want my current linux build to be documented and reproducible such that a complete rebuild, or a partial reacreation is not a time consuming trial and error effort.

## Overall approach
This is essentially a configuration management and automated deployment problem.

The base linux is debian and aimed at sid. The configuration management and automation is handled by ansible-pull with git providing versioning. The bare metal component is built on a debian preseed that bootstraps the initial ansible pull for a _from scratch_ build. 

Currently ansible pull is being added as a one-shot service that is run at boot time. The system will not have the ansible components installed until after the first boot has occured. The ansible-pull runs every boot - this should keep the system synchronised.

This git repo contains the intstructions everything for building and maintaining my linux environments - at some point the ansible playbooks will likely be separated.

## Principles
1. A rebuild needs to be reasonably hands off.
2. Updating the config needs to be straight forward - ideally live system changes are implemented first in the ansible config and then deployed from there.
3. Where 2. is impractical add a specific note/script documenting the system change so it's at least captured for later reference.


## Specifics
A preseed file is embedded in a debian sid netboot iso. This creates the base minimal deployment and sets up ansible-pull to run as a boot service through systemd.  

Embedding of the preseed and supporting files in the iso is automated/documented through a bash script.

Use [ventoy](https://ventoy.net/en/index.html) on a bootable USB to deploy the iso.

Everything else is handled by ansible.


# autolinux - mechanised
## preseed.cfg
Reasonably terse and readable preseed. Very basic partitioning. Only user input requested is the hostname.

## debside.iso (the modified mini.iso)
TODO: fix the grub text - currently barely readable on white image.
> [!NOTE]
> The installer only works while the kernel is relatively synchronised with the sid repos. This means you shouldn't assume an installer built now will work in a month.
> Further, desynchronisation can occur during the period where the kernel modules in the repo don't match the current netboot kernel for a couple of hours until the daily netboot is updated.

## update_preseed.sh
This script handles creation and updates of the customised debian sid iso. Pulls the most recent netboot iso.

## Pre-requisites and iso sources
```
wget https://d-i.debian.org/daily-images/amd64/daily/netboot/mini.iso
sudo apt install p7zip-full p7zip-rar genisoimage fakeroot xorriso isolinux binutils squashfs-tools
```

> [!NOTE]
> Pulling mini.iso is managed by update_preseed.sh; tools are assumed to be avaialable.


## Useful
To get the details of *this* debian machine
```
sudo debconf-get-selections --installer >> local-preseed.txt
```

## Process notes
Based on debian [sid](https://wiki.debian.org/DebianUnstable). Dev machine is debian bookworm host.

### Handling secrets
`ansible-vault` is used to manage sensitive data. To enable unattended running, a vault password [is used](https://docs.ansible.com/ansible/latest/vault_guide/vault_encrypting_content.html#creating-encrypted-variables). 
`update_pressed.sh` assumes you have a password file named `vault_pass`.

On linux - one way to create your vault_pass is:
```
tr -dc "[:graph:]" < /dev/random | head -c 1024 | xargs -0 > vault_pass
```

> [!CAUTION]
> Keep vault_pass secret - this means your iso/install disk need to be managed appropriately!

As a general precaution, the only secrets stored in the repo (with vault encryption) are relatively low risk. The user password is a hashed and salted value before encryption. The authorized keys file only contains public keys - the main reason to encrypt this file is to make it harder to inject a third party key into the file. Private keys *are not* stored here.



To generate a linux password hash for use with ansible users module:
```
openssl passwd -6
```


Creating a secret to embed in playbook:
```
ansible-vault encrypt_string --vault-password-file=vault_pass 'test-value' --name 'the_secret'
```


## References
### debian preseed
* Repacking iso images - [debian doco](https://wiki.debian.org/RepackBootableISO)
* Preseed [basics](https://wiki.debian.org/DebianInstaller/Preseed)
* Preseed in massive [detail](https://preseed.debian.net/debian-preseed/sid/amd64-main-full.txt)
* Possibly usefully concise preseed [examples](https://dev1galaxy.org/viewtopic.php?id=1853)
* Scripted ubuntu preseed generator [repo](https://github.com/covertsh/ubuntu-autoinstall-generator)

### ansible
* [Ansible-vault](https://docs.ansible.com/ansible/latest/vault_guide/vault_encrypting_content.html)
* [Important](https://docs.ansible.com/ansible/2.8/user_guide/playbooks_best_practices.html#directory-layout) pre-reading - really helps make sense of the directory layout.
* The template for my approach - [LearnLinuxTV](https://github.com/LearnLinuxTV/personal_ansible_desktop_configs)
