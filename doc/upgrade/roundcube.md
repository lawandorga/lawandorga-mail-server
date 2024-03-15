# Upgrade Roundcube's database

* After upgrading roundcube, we may have to manually upgrade its database.
    * `ls /usr/share/dbconfig-common/data/roundcube/upgrade/pgsql/`
    * See `/usr/share/doc/roundcube-core/README.Debian.gz`.
    * This should normally only be necessary after an
      [upgrade to a new Debian release](/doc/upgrade.md).


## Notes

* As per `roundcube-core`'s `README.Debian`, it should be possible to configure
  debconf to do this job for us.
* It might also be possible to use `/usr/share/roundcube/bin/update.sh`
  instead.
