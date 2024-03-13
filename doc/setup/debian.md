# Setup Debian

This document describes the setup of a basic Debian system.

Assumptions:

* The disks are fully set up and the file systems mounted.
* EFI booting.
* Debian Bookworm.
    - This guide should work largely unchanged for later versions of Debian.


## Overview

We use `debootstrap` to install Debian.
The common alternative would be to boot from special *installation media*.

A notable advantage of installing via `debootstrap` is the gained flexibility.
Also, at our current provider (Scaleway), installing from such installation
media is not made easy, while the preferred method is to install a
pre-compiled full Debian image.
This in turn does not even allow for partitioning.


## Process

We generally follow the *Debian GNU/Linux installation guide*'s section on
[Installing Debian GNU/Linux from a Unix/Linux System](https://www.debian.org/releases/bookworm/amd64/apds03.en.html).
(Note that this link is specific to Debian Bookworm.)
There will be references to subsections of this guide below.

Note that we use `/mnt` instead of `/mnt/debinst` as the mountpoint of our
root file system.

The actual needed steps are listed below, in order:

* `apt install debootstrap`  (c.f. D.3.2)
* `debootstrap --variant=minbase bookworm /mnt https://deb.debian.org/debian`
  (c.f. D.3.3)
    - `--variant=minbase`: Only packages of `Priority` `required` and their
      (transitive) dependencies are installed.
        - Notably, `ca-certificates` is additionally installed
          (due to our selecting an HTTPS mirror).
        - Otherwise, all packages of `Priority` `important` are considered.
        - This is to keep our installation minimal.
    - Note that all packages are installed as "manually" installed,
      including dependencies.
* Mount special file systems.
    - `mount --rbind /dev /mnt/dev`  (c.f. D.3.4.1)
    - `mount -t proc proc /mnt/proc`  (c.f. D.3.4.2)
    - `mount -t sysfs sysfs /mnt/sys`
    - `mount -t tmpfs tmpfs /mnt/tmp`
    - `mount --bind /sys/firmware/efi/efivars /mnt/sys/firmware/efi/efivars/`
* Provide custom configuration files.
    - From our local machine, run
      `scp -r LAWANDORGA_MAIL_SERVER_PATH/conf root@SERVER:/mnt/tmp/`.
* Enter chroot.  (c.f. D.3.4)
    - `LANG=C.UTF-8 chroot /mnt /bin/bash`
    - Note: In the following, all commands are to be executed from within the
      chroot, unless otherwise noted.
* Configure APT.
    - `install -Tm 0644 /tmp/conf/apt/sources.list.j2 /etc/apt/sources.list`
      (c.f. D.3.4.5)
    - `sed -Ei 's/\{\{ debian_release_codename \}\}/bookworm/g' /etc/apt/sources.list`
    - `install -Tm 0644 /tmp/conf/apt/10norecommends /etc/apt/apt.conf.d/10norecommends`
    - `install -Tm 0644 /tmp/conf/apt/09tempdir /etc/apt/apt.conf.d/09tempdir`
* Configure mount points.
    - `install -Tm 0644 /tmp/conf/fstab /etc/fstab`  (c.f. D.3.4.2)
    - `mkdir -p /tmps/apt`
    - `mount /tmps/apt`
* Update system.
    - `apt update`
    - `apt dist-upgrade`
* Configure timezone.  (c.f. D.3.4.3)
    - `printf '%s\n' '0.0 0 0.0' 0 UTC > /etc/adjtime`
    - `ln -sf /usr/share/zoneinfo/Etc/UTC /etc/localtime`
* Configure networking.  (c.f. D.3.4.4)
    - We shall assume a DHCP IPv4-only setup.
        - [This works well with Scaleway](/doc/setup/vm-scaleway.md).
    - `apt install ifupdown dhcpcd-base`
    - Figure out the ethernet interface name (`ip link show`).
    - `iface=IFACE_NAME`
    - `printf '%s\n' "auto ${iface}" "iface ${iface} inet dhcp" > /etc/network/interfaces`
    - `install -Tm 0644 /tmp/conf/network/dhcpcd.conf.j2 /etc/dhcpcd.conf`
    - `sed -Ei 's/^(allowinterfaces) .*$/\1 '"$iface"'/' /etc/dhcpcd.conf`
    - `printf 'exit 0\n' > /etc/dhcpcd.enter-hook`
    - `printf 'nameserver 9.9.9.9\n' > /etc/resolv.conf`
* Configure locale.  (c.f. D.3.4.6)
    - `printf '%s\n' 'LANG=C.UTF-8' > /etc/default/locale`
    - Note: To use any locale besides `C.UTF-8`, `C`, `POSIX`, the `locales`
      package would need to be installed and more configuration be done.
* Configure hostname and `/etc/hosts`.  (c.f. D.3.4.4)
    - `printf '%s\n' 'lawandorga-mail-server' > /etc/hostname`
    - `printf '%s\n' '127.0.0.1 localhost' '127.0.1.1 lawandorga-mail-server' > /etc/hosts`
* Install a kernel.  (c.f. D.3.5)
    - *Scaleway-specific:* `apt install linux-image-cloud-amd64`
        - See [notes on Scaleway](/doc/setup/vm-scaleway.md).
* Install and set up GRUB.  (c.f. D.3.6)
    - Install a suitable GRUB package.
        - *Scaleway-specific:* `apt install grub-cloud-amd64`
            - See [notes on Scaleway](/doc/setup/vm-scaleway.md).
    - Let `DISK_PATH` be the system disk's path (disk to install GRUB on).
        - See [disk setup](/doc/disks.md).
    - `grub-install --target=x86_64-efi --efi-directory=/boot/efi DISK_PATH`
        - *Scaleway-specific:* Add the flag `--force-extra-removable`,
            - See [notes on Scaleway](/doc/setup/vm-scaleway.md).
    - `update-grub`
* Install and configure an SSH server.  (c.f. D.3.7)
    - `apt install openssh-server`
    - `install -Tm 0644 /tmp/conf/ssh/sshd_config /etc/ssh/sshd_config`
    - `mkdir /etc/ssh/authorized_keys`
    - Install our public Ed25519 key(s) to `/etc/ssh/authorized_keys/root`.
        - `scp PATH_TO_ED25519_KEY root@SERVER:/mnt/etc/ssh/authorized_keys/root`
    - `groupadd -r ssh-users-pty`
    - `groupadd -r ssh-users-nopty`
    - `gpasswd -a root ssh-users-pty`
    - Obtain and note down the new server key fingerprint:
        - `ssh-keygen -lE sha256 -f /etc/ssh/ssh_host_ed25519_key.pub`
* Install further important packages.
    - `apt install lvm2 init libpam-systemd apparmor python3`
        - `libpam-systemd`:
            - Recommended by `systemd-sysv` (dependency of `init`)
            - package desc.: "If in doubt, do install this package."
        - `python3`: Needed for Ansible.
* Install and set up the firewall.
    - `apt install nftables netbase`
    - `cp -Tr /tmp/conf/nftables/aux/ /etc/nftables/`
    - `install -Tm 0755 /tmp/conf/nftables/setup-initial.nft /etc/nftables.conf`
    - `systemctl enable nftables.service`
* Shutdown the system (from outside the chroot: `halt -p`).
* Boot the newly installed system.
* Connect via SSH to the newly installed system.
    - Note that connecting to the IPv6 address won't work.
    - The fingerprint of the old system should fail verification
      and is to be removed
      (but maybe noted down in case the old system is ever to be used again).
    - Verify the new server key fingerprint noted down earlier.
