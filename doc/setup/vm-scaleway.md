# Initial setup of a VM (Scaleway specific)

* Goal: SSH access to a VM with secondary disks for the new system.


## Setup new VM with installation environment

1. Create a new "instance".
    - name: lawandorga-mail-server
    - OS: Debian
    - disks:
        - Target disks:
            - See [/doc/disks.md](/doc/disks.md).
            - Note: Scaleway uses SI prefixes (e.g., 1 GB = 10^9 B), while we
              (implicitly) use binary-multiple prefixes (e.g., 1 GiB = 2^30 B).
                - I.e., our sizes must be multiplied by a multiple of 1.024.
        - Bootstrapping disk:
            - Scaleway storage type: *block storage*
            - name: bootstrap-system
            - size: 10GB
            - Mark this (!) the boot/system disk
              (Scaleway will install Debian here).
    - network: "routed public IP", not "NAT public IP" (legacy)
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
        - It may be advisable to reboot after this; e.g., in case of a kernel
          upgrade.
    4. Set some decent temporary root password (`passwd`).
    5. Connect via web console, login with new password.
        - `ssh-keygen -lE sha256 -f /etc/ssh/ssh_host_ed25519_key.pub`
        - Compare with fingerprint accepted on first connection.
            - If they are distinct, check again, then start over.
    6. Unset root password (`passwd -d root`).
3. Adjust the IPv4 address in Ansible's [`hosts.yaml`](/ansible/hosts.yaml).


## Notes on next steps

Before following the subsequent steps in the [setup process](/doc/setup.md),
read the following Scaleway specific notes:

* General.
    - An EFI setup is required.
* [Disk setup](/doc/disks.md)
    - The disks should be visible at `/dev/sda` and `/dev/sdb`, but we cannot
      rely on the order.
* [Debian installation](/doc/setup/debian.md)
    - Network setup:
        - Only use IPv4.
            - Background: Until recently, Scaleway did not properly support
              IPv6.
        - Use DHCP.
            - Reason: The IPv4 gateway address is assumed not to be static.
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
  [EFI shell](/doc/setup/vm-scaleway/efi/shell.md).
    - If so, boot from there and check our
      [EFI setup](/doc/setup/vm-scaleway/efi.md).
* Otherwise, reboot into the initial bootstrap system via
  "Instances" -> INSTANCE-NAME -> "Advanced Settings" -> "Boot Volume".


[gremwell-ssh-mitm]: https://www.gremwell.com/ssh-mitm-public-key-authentication
[ssh-mitm-doc]: https://docs.ssh-mitm.at/
