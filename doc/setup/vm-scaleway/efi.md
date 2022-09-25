# EFI peculiarities (Scaleway)

For proper operation, Scaleway requires an EFI binary at the default path,
`esp:/EFI/BOOT/BOOTX64.EFI`.

Without this, upon booting a system from the web interface (in particular when
booting our new system the first time), our own EFI boot entries (likely all
associated with that ESP) are removed and we are likely dropped into an EFI
shell.  Rebooting normally from within the installed system (`reboot`) does
not cause any of our EFI boot entries to disappear.

We install an EFI binary at that default path via the
`--force-extra-removable` flag to `grub-install`
(see also [Scaleway setup](doc/setup/vm-scaleway.md)).

Note that upon upgrades of our installed GRUB package, `grub-install` will
likely be run without that flag.  This should be OK: The binary at the default
path will not be removed and seems not to be actually used.


## Debugging

* From within an installed Debian system, `efibootmgr` (package `efibootmgr`)
  can show (`-v`) and manage EFI boot entries.
* To fix the EFI boot entries from an installed Debian system,
  re-run `grub-install` with `--force-extra-removable`.
* If the system fails to boot due to removed EFI boot entries,
  see [EFI Shell](/doc/setup/vm-scaleway/efi/shell.md).


## See also

* https://www.rodsbooks.com/efi-bootloaders/principles.html
