# Static aliases (and sender login maps)

* See [aliases](/doc/mail/postfix/aliases.md) for general documentation on
  aliases.
* Static aliases are such where the source address has a static domain
  (e.g., `$myorigin`).
* [Configuration file](/ansible/roles/mail/postfix/templates/maps/static-aliases.j2).


## Postmaster aliases

* See [postmaster addresses](/doc/mail/postfix/postmaster.md).


### Static domains

* For each static domain, we alias its postmaster address.


### IP addresses

* To alias mail for postmaster at `$inet_interfaces` and `$proxy_interfaces`,
  we can use the `postmaster` key in our `virtual(5)` alias table.
    * Note that this is compatible with `${smtpd_sender_login_maps}`, so we
      could even send from such addresses.
    * The key `postmaster` does not generally match the literal `postmaster`
      address, see below.
    * This also matches for the domains `$mydestination` and `$myorigin`.
        * `$mydestination` is empty.
        * `$myorigin` is matched explicitly, which takes precedence.
    * See `virtual(5)`, `postconf(5)#smtpd_sender_login_maps`.


### The literal postmaster address

* The literal `postmaster` address must also be aliased.
* We do not want to be able to send as literal `postmaster`.
    * It is generally not a proper address.
    * Postfix should generally not allow a sender address without domain, or
      (when locally submitted) append `@$myorigin` (provided that
      `$append_at_myorigin = yes`).
* The `virtual(5)` man page only considers queries of the form `user@domain`.
    * When `$append_at_myorigin = yes` (default; our setting), `postmaster`
      is apparently rewritten to `postmaster@$myorigin`.
        * We match this explicitly, anyways.
        * Note that `postconf(5)#append_at_myorigin` claims "\[w\]ith remotely
          submitted mail, \[...\] the string '@$remote_header_rewrite_domain'
          \[is appended\] instead".
            * This seems not to be the case here.
    * When `$append_at_myorigin = no`, we can apparently match `postmaster`
      (or what it is rewritten to) via a `postmaster` key in the `virtual(5)`
      aliases table.
        * Note that this is not supposed to match literal `postmaster`, see
          above.


## Regular aliases

* Any number of regular aliases can be added.
