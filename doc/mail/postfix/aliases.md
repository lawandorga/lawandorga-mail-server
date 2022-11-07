# Aliases (and sender login maps)

* All our domains are virtual, so we cannot use local `aliases(5)`.
* Instead, we use `virtual(5)` aliases (`$virtual_alias_maps`).
    * These can relate any two addresses via an alias.
* We allow all alias owners to send from their aliases, via
  `$smtpd_sender_login_maps`.
    * We generally reuse our alias maps here, so we need to make sure their
      format is compatible with that of `$smtpd_sender_login_maps`.


## Static vs. database aliases

Static aliases take precedence over database aliases.

* [Static aliases](/doc/mail/postfix/aliases/static.md).
* [Database aliases](/doc/mail/postfix/aliases/database.md).


## Postmaster aliases

See [postmaster addresses](/doc/mail/postfix/postmaster.md).


## Precedence

* We can generally enforce precedence by querying one map before the other.
* However, the specificity of the keys searched for trumps the precedence rules
  set by the order of the maps.
    * The order of precedence (from high to low):
        1. "user@domain"
        2. "user"
        3. "@domain"
    * See `virtual(5)` and `postconf(5)#smtpd_sender_login_maps`.


## Sender login maps

* As noted initially, we reuse our alias tables to allow alias owners to send
  from their aliases.
* Note that our SASL login names are simply the accounts' primary addresses.
    * Aliases do not count here.
* Note that unlike `virtual(5)` aliases, `${smtpd_sender_login_maps}` does
  not recurse.
    * I.e., aliases are not transitive w.r.t. sending from them.
* We additionally need to allow sending from the respective primary address.
    * This is achieved via an identity map.
    * Sending from an alias should only be allowed if there is no account with
      that address.
        * Such aliases should generally not exist; this is only a safeguard.
        * I.e., the identity map should take precedence over the alias map.
        * Exception: Postmaster aliases must take precedence.
    * Note that actual accounts only exist in the database, and none are
      statically configured.
