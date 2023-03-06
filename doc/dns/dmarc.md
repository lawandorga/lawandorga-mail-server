# DMARC records

* `TXT` record:
    * key: `dmarc.<MAILSERVER_DOMAIN>`
    * value: `v=DMARC1; p=reject; adkim=s; aspf=s`
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


## Technical remarks

* The `v` tag must come first, the `p` tag probably second.
    * The wording in the relevant RFC 7489 is not that clear in my opinion:
      It says these two tags "MUST appear in that order" (sec. 6.3)--the order
      found in the formal ABNF of section 6.4 and "components other than
      dmarc-version and dmarc-request may appear in any order" (sec 6.4), where
      these correspond to the `v` and `p` tags, respectively.


## See also

* RFC 7489
* [Wikipedia:DMARC](https://en.wikipedia.org/wiki/DMARC)
