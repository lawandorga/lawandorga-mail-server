# Scaleway-specific packages

The Scaleway-provided Debian image (Debian Bullseye; installed 2022-09-18)
contains the following packages I believe are non-standard:

* linux-image-cloud-amd64
    - This should be our choice of kernel.
* grub-cloud-amd64
    - This should be our choice of GRUB, if any.
    - Also note the non-standard `/etc/default/grub`.
* cloud-guest-utils
* cloud-init
* cloud-initramfs-growroot
    - This we definitely do not need.
* chrony (time sync daemon)
* efibootmgr
    - This may actually be standard on EFI systems.
* ethtool
* scaleway-ecosystem
    - Provided by a custom respository.
    - Enables some fancy interoperability with the Scaleway web admin
      interface and likely API.
        - E.g., automated installation of SSH keys.
        - At least some of those features would not work.
            - We have a read-only root, which those tools do not expect.
            - We install SSH keys in a non-default location.
    - Some parts of this may be useful.

This list was determined by briefly going over the packages listed by
`apt-mark showmanual`.  It may very well be incomplete.

None of the above packages are installed on our final system unless noted
elsewhere.
