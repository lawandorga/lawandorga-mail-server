# Disks

## Overview

### system disk

This disk is to contain the operating system data, including its configuration,
but excluding state data that is deemed valuable.

Generally, the idea is that losing all data on this disk should not require
a use of a backup, but merely a re-installation (configuration should be done
mainly via Ansible, see [Overview](/doc/overview.md)).

Conversely, a reinstallation of the system would ideally start from scratch
on this disk.


### data disk

This disk should contain all valuable state.  Notably, the email data, but also
secrets that are to persist a reinstallation and are not managed via Ansible.

This may additionally contain other data that does not fit on the system disk,
which (assuming the below *Scaleway-specific* setup) is limited in size.


## Disk layout

### system disk

*Scaleway-specific:* This disk is based on *local storage* and should be
visible as `/dev/vda` on the machine.
    - *Local storage* is apparently limited to 20GB (< 20GiB) and cannot be
      resized post creation.

We assume an EFI setup.

* size: 10G
    - This is generous, to leave a some space for LV snapshots.
* GPT partition table
    1. "ESP"   - 128M        - vfat - /boot/efi
        - partition type: EFI system partition (`gdisk`: `EF00`)
    2. "nolvm" - 128M        - ext4 - /var/nolvm
        - This is for LVM metadata backups.
    3. "main"  - *remainder* - LVM
        * "root"    - 2G   - ext4 - /
        * "var"     - 1G   - ext4 - /var
        * "var-log" - 2G   - ext4 - /var/log
        * "var-tmp" - 1G   - ext4 - /var/tmp
        * "home"    - 128M - ext4 - /home


### data disk

*Scaleway-specific:* This disk is based on *block storage* and should be
visible as `/dev/sda` on the machine.

* size: 16G
    - This is just an initial size and should be expanded once the need arises.
    - As for the system disk, this should be a little more than needed to allow
      for LV snapshots.
* MBR partition table
    1. "data" - *full-size* - LVM
        * "mail-data"     - 5G - ext4 - /var/mail
        * "static-data"   - 4M - ext4 - /persistent
        * "variable-data" - 4M - ext4 - /persistent/var
        * "var-cache"     - 8G - ext4 - /var/cache
* Notes:
    - We could also skip the partition table layer, given that there is only
      one partition (and no need for an MBR to boot from).
    - The large size of the LV mounted at `/var/cache` is due to `restic`'s
      need for a large cache.
      See [here](/ansible/roles/backup/vars/main.yaml).


## Setup

* Required uncommon software packages: `dosfstools`, `lvm2`.
* MBR partitioning: E.g., `fdisk` or `parted`.
* GPT partitioning: E.g., `gdisk` or `parted`.
* *EFI System Partition (ESP)*
    * Let `/dev/vdXN` be the *ESP*.
    * `mkfs.fat -F 32 -n ESP /dev/vdXN`
* LVM
    * Let `/dev/vdXN` be a partition to install LVM on.
    * Let *VGNAME* be the name of the volume group.
    * `pvcreate /dev/vdXN`
    * `vgcreate VGNAME /dev/vdXN`
    * For each LV *NAME* of size *SIZE*:
        - `lvcreate -n NAME -L SIZE VGNAME`
        - `mkfs.ext4 -L NAME /dev/VGNAME/NAME`
* For each partition `/dev/vdXN` to format directly (as ext4; name *NAME*):
    - `mkfs.ext4 -L NAME /dev/vdXN`
* Mount all new file systems under `/mnt`, in the correct order (e.g., "var"
  before "var-log"), and create mountpoints as necessary.


## Reasoning

### Why several filesystems / mountpoints?

* Isolated failure.
    - Should a disk ever fail, or grow full (without being noticed early),
      a large part of the system is unimpacted.
        - Notably, `/var/log` should contain relevant logs in case of
          a problem with any other filesystem.
* Restrictive mount options.
    - `/` can be mounted read-only, all other (regular) file systems can be
      mounted with `nosuid` and `nodev`, most further with `noexec`.


### Why LVM?

* Snapshots.
    - These allow for backups of the data at a single point in time.
        - Note that the snapshots themselves do not (!) constitute backups.
* Easy resizability.

An alternative solution to both of these points would be to use individual
disks/"volumes", one for each file system, and to create snapshots externally.
