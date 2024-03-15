# Unbound: File ownership

## Desired state

* Most files can be root-owned, and, thus, should be root-owned.
    * Notably, `/var/lib/unbound/`.
* `/var/lib/unbound/root_key/` and its children must be writable by
  `unbound:unbound`.
    * Usually, the only child should be`/var/lib/unbound/root_key/root.key`,
      but there may also be temporary files.
    * See:
        * [our `unbound.conf`](/ansible/roles/common/dnssec-resolver/files/unbound.conf)
        * `unbound.conf(5)#auto-trust-anchor-file`


## Relevant information

* We do not configure `User=` in `unbound.service`, which defaults to `root`.
* We configure `StateDirectory=unbound` in `unbound.service`.
    * This declares `/var/lib/unbound/` the state directory, to be owned by
      the systemd service user and group (`root:root`).
    * This effectively causes a `chown -R root:root /var/lib/unbound/` on
      service start--if `/var/lib/unbound/` is not owned by `root:root` at that
      time.
* Unbound drops privileges to `unbound:unbound` soon after starting.
* The Debian `unbound` package, as of version `1.17.1-2+deb12u2`, contains a
  postinst script that runs `chown unbound:unbound /var/lib/unbound/`.


## Problem

* On upgrade (or reinstallation) of the `unbound` package,
  `/var/lib/unbound/root_key/` is effectively recursively chown'd to
  `root:root`, causing Unbound to fail.
    * First, `/var/lib/unbound/` is chown'd to `unbound:unbound`.
    * Second, on service restart, `/var/lib/unbound/` is recursively chown'd
      to `root:root`.
* Note: The problem does not occur on initial installation, done by Ansible.
    * Tasks run after the installation set up the correct file ownerships.


## Potential solutions / workarounds

### Solutions 1.\*: Avoid the chown'ing by dpkg

#### Solution 1.1: Let `/var/lib/unbound` be owned by `unbound:unbound`

* We would have to either drop using `StateDirectory=` or set `User=unbound`
  in the systemd service.
    * In the latter case, we'd probably have to prefix the `ExecStart=` command
      with `!`.
* This contrasts with our desired state of `/var/lib/unbound` being owned
  by `root:root`.
    * This might be deemed ok, though.


#### Solution 1.2: Prevent dpkg from chown'ing

* There is no easy way to disable a postinst script.
* We might be able to prevent dpkg from successfully (!) chown'ing the
  directory (i.e., somehow deny it the needed write access).


#### Solution 1.3: Hide the content of the state directory from dpkg

* We might be able to hide the "actual" `/var/lib/unbound` from dpkg, by
  bind-mounting it from elsewhere, only in the systemd service.


#### Solution 1.4: Change the state directory

* In the package's post-install script, the path `/var/lib/unbound/` is
  hard-coded.
* Unsure where the directory should be located.
    * `/var/local/`?
    * `/var/lib/`?
* This would require adapting the Apparmor profile provided with the `unbound`
  package.


### Solutions 2.\*: Undo the initial chown'ing

#### Solution 2.1: Let apt/dpkg trigger the undoing of its chown'ing

* We'd effectively want a post-install hook.
    * `Post-Invoke` (see apt.conf(5)) might offer that.
        * Note that this appears to be a global setting, not possible to only
          apply to a single package.


#### Solution 2.2: Let the systemd service undo the initial chown'ing

* We cannot do this in `unbound.service` directly; it's too late then.
* We might be able to achieve this with a new systemd service scheduled to
  run before start of `unbound.service`.


### Solutions 3.\*: Work around the consequences of the initial chown'ing

#### Solution 3.1: Protect specific files from the recursive chown'ing

* Bind-mounting `/var/lib/unbound/root_key/` from elsewhere might work.


#### Solution 3.2: Re-chown specific files via the systemd service

* `ExecStartPre=+/bin/chown ...`


## Choice of solution / workaround

* None of the above "solutions" is deemed great.
* We choose "solution" 3.2 for now, mostly due to its simplicity to apply.
