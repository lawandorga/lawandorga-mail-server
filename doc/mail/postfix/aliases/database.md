# Database aliases (and sender login maps)

* See [aliases](/doc/mail/postfix/aliases.md) for general documentation on
  aliases.
* In each SQL query, we explicitly ignore static domains.
    * There should never be an overlap between static and database-configured
      domains in the first place; this is just a safeguard.
    * This means that, effectively, the configured precedence between static
      and database aliases does not matter.


## Precedence

* Postmaster aliases are to take precedence over regular aliases.


## Postmaster aliases

* See [postmaster addresses](/doc/mail/postfix/postmaster.md).
* For each database-configured domain, we alias its postmaster address.
    * [Configuration](/ansible/roles/mail/postfix/templates/maps/postmaster-aliases.pgsql.cf.j2).


## Regular aliases

* Each database-configured account may have an arbitrary amount of aliases,
  but only within the same domain.
* Each alias has exactly one target.
* [Configuration](/ansible/roles/mail/postfix/templates/maps/aliases.pgsql.cf.j2).


### Sender to login map

* As noted in the general [aliases notes](doc/mail/postfix/aliases.md), we need
  to add an identity map on the users for the `$smtpd_sender_login_maps`.
    * Our SQL schema makes it simpler to write a single query for the union
      map of the aliases map and the identity map.
        * In particular, no alias address is also a regular user address.
            * I.e., the union map is a well defined partial function.
        * [Configuration](/ansible/roles/mail/postfix/templates/maps/sender-to-login.pgsql.cf.j2)
