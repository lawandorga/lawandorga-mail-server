# DKIM

This is only concerned with our own DKIM key(s).


## Selector

* We use a selector of the form `YYYY-MM.law-orga`.
    * This is configured
      [here](/ansible/host_vars/lawandorga-mail-server/mail.yaml).
    * The `YYYY-MM` corresponds to the key creation date.
* Why we include the date:
    * RFC 6376 recommends new selector for a new key.
* Why we include our name:
    * This way, users of our mail server can easily distinguish the DKIM TXT
      record for our mail server from any potential DKIM TXT records for
      other mail servers.


## DNS records

* `TXT` record:
    * key: `<SELECTOR>.dkim.<MAILSERVER_DOMAIN>`.
    * value: Take from `/persistent/opendkim/<SELECTOR>.txt`.
        * See the `mail_opendkim_key_dir` Ansible variable.
        * This assumes the key was already generated.
            * See [Ansible setup](/doc/ansible.md).
* `CNAME` record:
    * key: `<SELECTOR>._domainkey.<CLIENT_DOMAIN>`
    * value: `<SELECTOR>.dkim.<MAILSERVER_DOMAIN>`
