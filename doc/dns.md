# DNS

## Security (DNSSEC)

* All domains should use DNSSEC.
    * Notably, our mail server's domain, and all domains served by our mail
      server.
    * See also [DANE](/doc/dns/dane.md).
* See [DNSSEC](/doc/dns/dnssec.md).


## DNS configuration

To be able to use this mail server, several records need to be set in the DNS.

* In the following, let
    * `<MAILSERVER_DOMAIN>` be the domain name of our mail server,
    * `<MAILSERVER_IPv4_ADDRESS>` be the IPv4 address of our mail server.
        * See [Ansible's `hosts.yaml`](/ansible/hosts.yaml).
    * `<CLIENT_DOMAIN>` be a domain name desiring to use our mail server.
        * This may be equal to `<MAILSERVER_DOMAIN>`.
        * Any DNS records listed for `<CLIENT_DOMAIN>` must be configured for
          any such domain.
* For our own mailserver, we need:
    * `A` record:
        * key: `<MAILSERVER_DOMAIN>`
        * value: `<MAILSERVER_IPv4_ADDRESS>`
    * `PTR` (reverse DNS) record:
        * key: reverse DNS key for our mail server's IP address.
        * value: `<MAILSERVER_DOMAIN>`
    * [DANE](/doc/dns/dane.md).
* For each domain using our mail server:
    * We generally prefer to use indirection, to not duplicate information
      that generally only ever changes globally.
    * See
        * [MX](/doc/dns/mx.md),
        * [SPF](/doc/dns/spf.md),
        * [DKIM](/doc/dns/dkim.md),
        * [DMARC](/doc/dns/dmarc.md).
