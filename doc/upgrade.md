# Upgrading to a new Debian release

On upgrade to a new Debian release, the following should be done:

1. Update this documentation and code:
    * Read the Debian release notes.
    * Read relevant changelogs.
        * Notably, see `/usr/share/doc/<pkgname>/`.
    * Make appropriate changes.
2. Re-install (or upgrade) the system.
    * If re-installing, migrate the data.
    * If re-installing on a separate machine (running in parallel for some
      time):
        * Initially use different IP address(es), but finally switch to the
          old IP adress(es).
            * This is to retain the IP address reputation w.r.t. e-mail.
        * Initially set up a distinct webmail database
          (`database_name_webmail`).
            * Using the same general mail database (`database_name_mail`) is
              fine.
3. [Upgrade Roundcube's database.](/doc/upgrade/roundcube.md)
