# DANE

* Precondition: Our domain is secured by [DNSSEC](/doc/dns/dnssec.md).


## Notes on Security

* DANE security is limited by the security of the DNSSEC keychain.
    * See [DNSSEC](/doc/dns/dnssec.md).


## DNS records

* `TLSA` record:
    * key: `_25._tcp.<MAILSERVER_DOMAIN>`
    * value: `3 1 1 <PUBKEY_HASH>` 


## Public key hash

* To generate the public key (sha256) hash, on the mail server, run:
    * `openssl rsa -in <KEYPATH> -pubout -outform der | sha256sum`
        * The `-pubout` flag is important!
        * To determine `<KEYPATH>`, see the corresponding
          [Ansible configuration](/ansible/roles/tls/key/vars/main.yaml).


## Reasoning

* We use our own public key, not that of our CA.  (first field `3`)
    * The only reason to use the CA's key would IMHO be the use of several,
      or frequently changing keys.
    * We use a single key, which does not usually change.
* We sign the public key itself, not a certificate.  (second field `1`)
    * This suffices.
    * The certificate changes regularly.
* We use SHA-256.  (third field: `1`)
    * Alternatives are:
        * no hashing (provide full public key)
            * Large; DNS records may be too small.
        * SHA-512
            * Unsure whether as widely supported as SHA-256.
    * SHA-256 is deemed sufficiently secure.
