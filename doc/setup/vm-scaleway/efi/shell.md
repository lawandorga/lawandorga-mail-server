# EFI Shell (Scaleway)

To find out whether we are dropped into an EFI shell (and to access it),
we can connect to our VM via "serial console", either via

- the web interface ("Instances" -> INSTANCE-NAME -> "Console"), or
    - At least on Firefox, this is often very unresponsive.
      Chromium seems not be fine in this regard.
- the [CLI](https://github.com/scaleway/scaleway-cli/blob/master/docs/commands/instance.md#connect-to-the-serial-console-of-an-instance).


## Boot GRUB from EFI Shell

* `cls` - Clear screen.
* `map` - List file systems (ESPs).
    - Our new disk's ESP should be associated with something like `HD(1, ...`,
      in contrast to `Scsi(15, ...` for the provided image's ESP.
* `FS1:` - Select file system 1 (assuming this is our ESP).
* `cd EFI`
* `cd debian`
* `grubx64.efi` (`shimx64.efi` works as well.)
