# DMARC records

* `TXT` record:
    * key: `dmarc.<MAILSERVER_DOMAIN>`
    * value: `v=DMARC1; adkim=s; aspf=s; p=reject`
* `CNAME` record:
    * key: `_dmarc.<CLIENT_DOMAIN>`
    * value: `dmarc.<MAILSERVER_DOMAIN>`


## Reasoning

* For both DKIM and SPF, we want strict alignment (`adkim=s`, `aspf=s`).
    * This means that we require the domain to match exactly.
    * Otherwise, "foo.example.org" and "bar.example.org" would match.
* We do not use failure reporting (`rua=`, `ruf=`).
    * This might be a privacy issue.
        * Aggregate reports (`rua=`) are likely less of an issue.
    * Otherwise, we'd have to allow all `<CLIENT_DOMAIN>`s to list the
      report address (assumed `@<MAILSERVER_DOMAIN>`).
        * See [Wikipedia:DMARC#Records](https://en.wikipedia.org/wiki/DMARC#Reports).
        * Due to the set of `<CLIENT_DOMAIN>`s being dynamic, we'd probably
          have to allow any domain.
            * See [the DMARC FAQ on this issue](https://dmarc.org/wiki/FAQ#How_can_I_put_DMARC_records_on_many_domains_at_once.3F).
        * Alternatively, we could give up our unified DMARC record and
          specify something like `postmaster+dmarc-reports@<CLIENT_DOMAIN>`
          as report address.
            * Note that `postmaster` is the only localpart for which we get
              mail for all configured domains ourselves.


## See also

* RFC 7489
* [Wikipedia:DMARC](https://en.wikipedia.org/wiki/DMARC)
