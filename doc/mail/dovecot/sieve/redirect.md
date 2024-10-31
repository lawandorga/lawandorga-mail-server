# Sieve `redirect`

* The Sieve `redirect` command allows to relay a message to another recipient.
* The command is part of core Sieve (RFC 5228) (i.e., not part an extension).
* We can globally configure the `redirect` command via:
    * `sieve_max_redirects` (`0` meaning to effectively disable the command)
    * `sieve_redirect_envelope_from`


## Problems

### Privacy issues

* Senders generally do not expect their mail to be forwarded to a third
  party mail server.
    * Forwarding to a different account on the same server should be
      acceptable; users should be aware that (auto) forwarding mail means that
      somebody else gets access to it, while they may be less aware that
      other mail server operators also get access to it.
* Users may be tempted to forward mail to a mail server with weak privacy
  protections and/or security.
* Desired solution: Restrict recipients to such local to our server.
    * In practice, though, there does not seem to be an easy way to configure
      this.


### Technical issues

* Bounces
    * We generally want to avoid bounces (in favor of rejects).
    * If the relayed to server rejects our message, we generate a bounce.
    * The relayed-to server (or another server, further down the chain) may
      itself generate a bounce.
    * Solution: Send bounce to the account that configured the `redirect`.
      I.e., modify envelope sender: `sieve_redirect_envelope_from = recipient`
    * See also: `/ansible/roles/mail/dovecot/sieve/vars/main.yaml`
      (`{{ mail_dovecot_sieve_extensions }}` -> automated mail sending).
* SPF
    * Solution 1: `sieve_redirect_envelope_from = recipient` or similar
    * Solution 2: Sender Rewriting Scheme (SRS)
* DMARC
    * If we modify the envelope sender, we generally break DMARC alignment.
    * Desired solution 1: Restrict recipients to such local to our server.
        * Not practicable, see "Privacy issues" -> "Desired solution".
        * This assumes we do not check DMARC for locally originating mail.
    * Desired solution 2: Also modify the header from address.
        * Possible via Sieve.
        * Probably not easily possible to do automatically.
        * We might want to generally reject mail with unaligned header from
          and envelope from addresses; this would "solve" this issue.


## Solution (for now)

* By default, disable redirects.
* Allow enabling redirects via Ansible host vars.
* Rewrite the sender of redirected messages to an address associated with the
  redirecting account.
* Inform users with the ability to install sieve scripts that redirects should
  be internal.
    * External redirects (which would require rewriting the header from
      address) should remain an exception.
    * As long as ManageSieve is not set up, most users cannot directly install
      sieve scripts.


## Alternative solutions

### Shared folders

* Shared folders plus `fileinto` can arguably solve most problems otherwise
  solved by local (!) redirects.
* Drawback: The original final recipient's account can delete messages in the
  shared folder, potentially before the shared-with accounts had a chance to
  read or copy it.
* Drawback: Not well suited for many different (or even dynamic) sets of
  forwarding recipients.
    * One folder is needed for each forwarding relationship; i.e., the
      forwarder and the set of forwarding recipients.


### External copying (via IMAP)

* Users with access to an account via IMAP can copy/synchronise select e-mail
  messages to/with another server.
    * It may be helpful to sort to-be-shared mail into specific folders via
      Sieve first.
* This is a fallback solution that works even if the server does not allow
  redirecting (or something similar).
* This "solution" seems ill-suited for group accounts, where (at least / best
  exactly) one group member would have to set this up.
