# Upgrading to a new Debian release

On upgrade to a new Debian release, the following should be done:

1. Update this documentation and code:
    * Read the Debian release notes.
    * Read relevant changelogs.
        * Notably, see `/usr/share/doc/<pkgname>/`.
    * Make appropriate changes.
2. Re-install (or upgrade) the system.
    * If re-installing, migrate the data.
    * If (temporarily) running two systems in parallel, make sure to use
      different databases for Roundcube.
3. [Upgrade Roundcube's database.](/doc/upgrade/roundcube.md)
