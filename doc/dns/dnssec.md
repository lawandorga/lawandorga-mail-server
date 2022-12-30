# DNSSEC

* DNSSEC serves to authenticate (parts of) the DNS.


## Reasons w.r.t. E-Mail

* Unlike the WWW, E-Mail communication (between mail servers) does not
  generally use authentication via a PKI.
* E-Mail largely relies on the DNS being trustworthy.
    * This includes all relevant records, notably `MX` records.
* See also [DANE](/doc/dns/dane.md).


## Shortcomings of DNSSEC

* The security of DNSSEC is limited by the weakest link in the key chain.
    * In practice, keys are often of relatively small sizes.
        * E.g., as of 2022-12-29, the *zone signing key* of `de.` is a 1024-bit
          RSA key.  (The *key signing key* is a 2048-bit RSA key, however.)
