# Initial setup of a VM (Scaleway specific)

* Goal: SSH access to a VM with secondary disks for the new system.


## Setup new VM with installation environment

1. Create a new "instance".
    - name: prod-mail.law-orga.de
    - OS: Debian
    - disks
        - *local storage* - 10G - "system"
        - *block storage* - 10G - "data"
        - *block storage* - 10G - "bootstrap-system"
            - Mark this (!) the boot/system disk
              (Scaleway will install Debian here).
        - See also [/doc/disks.md](/doc/disks.md).
        - Notes on Scaleway storage types:
            - Scaleway only allows one *local storage*.
            - *Block storage* has the advantage to be easily moved
              to a different VM, while being more expensive.
2. Set up SSH connection to SCW-provided image.
    1. Make sure public key authentication (i.e., a public key) is correctly
       configured with Scaleway.
    2. Connect via SSH.
        - `ssh -o HostKeyAlgorithms=ssh-ed25519 -o ForwardAgent=no -o PreferredAuthentications=publickey root@SERVER`.
        - We cannot yet verify the SSH server key fingerprint, so for now
            - accept it,
            - note it down (!).
        - It is important to use public-key client authentication, to prevent
          MITM attacks.
            - See [this article][gremwell-ssh-mitm],
              and also the [documentation on ssh-mitm][ssh-mitm-doc].
    3. `apt update && apt dist-upgrade`
    4. Set some decent temporary root password (`passwd`).
    5. Connect via web console, login with new password.
        - `ssh-keygen -lE sha256 -f /etc/ssh/ssh_host_ed25519_key.pub`
        - Compare with fingerprint accepted on first connection.
            - If they are distinct, check again, then start over.
    6. Unset root password (`passwd -d root`).


## Notes on next steps

Before following the subsequent steps in the [setup process](/doc/setup.md),
read the following Scaleway specific notes:

* General.
    - An EFI setup is required.
* [Disk setup](/doc/disks.md)
    - The "system" disk should be visible at `/dev/vda`.
    - The "data" disk should be visible at `/dev/sda` or `/dev/sdb` and be
      unused.
* [Debian installation](/doc/setup/debian.md)
    - Network setup:
        - Scaleway assigns us a private IPv4 address behind a NAT that
          we can obtain via DHCP (together with the route and DNS server).
        - We also get a static IPv6 address, which we do not use during setup.
    - As kernel, choose `linux-image-cloud-amd64`.
        - See [Scaleway-specific packages](/doc/setup/vm-scaleway/packages.md).
    - As GRUB package, install `grub-cloud-amd64`.
        - See [Scaleway-specific packages](/doc/setup/vm-scaleway/packages.md).
    - To install GRUB:
        - Add the flag `--force-extra-removable` to `grub-install`.
            - This will notably create a boot entry at the default path
              `esp:/EFI/BOOT/BOOTX64.EFI`.
            - On why, see the [notes on EFI](/doc/setup/vm-scaleway/efi.md).
    - To boot from the newly installed system:
        - Change the "boot volume" at
          "Instances" -> INSTANCE-NAME -> "Advanced Settings" -> "Boot Volume".


## Debugging

If the our new `deboostrap`-installed Debian system fails booting:

* Check if we are dropped into an
  [EFI shell](doc/setup/vm-scaleway/efi/shell.md).
    - If so, boot from there and check our
      [EFI setup](doc/setup/vm-scaleway/efi.md).
* Otherwise, reboot into the initial bootstrap system via
  "Instances" -> INSTANCE-NAME -> "Advanced Settings" -> "Boot Volume".


[gremwell-ssh-mitm]: https://www.gremwell.com/ssh-mitm-public-key-authentication
[ssh-mitm-doc]: https://docs.ssh-mitm.at/
