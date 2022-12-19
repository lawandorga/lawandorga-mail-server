# Ansible configuration

## Configure secrets

See [Ansible secrets](/doc/ansible/secrets.md).


## Generate DKIM key

1. Check if we already have a DKIM key configured.
    * Check the DNS, see [DKIM DNS records](/doc/dns/dkim.md).
    * On the server, check `/persistent/opendkim/`.
        * See the `mail_opendkim_key_dir` Ansible variable.
2. If all is set up properly and no key change is desired:
    * Nothing to be done; abort.
3. Choose a new DKIM key selector.
    * See [DKIM DNS records](/doc/dns/dkim.md).
4. Configure the [DKIM DNS records](/doc/dns/dkim.md).
    * On initial setup, this can be delayed until after the mail server is
      fully configured, see [Overview](/doc/overview.md).
5. Configure `mail_opendkim_key_selector` in
  `/ansible/host_vars/lawandorga-mail-server/mail.yaml`.
6. From the `ansible/` directory, run
   `ansible-playbook generate-opendkim-key.yaml`.
    * This will do nothing if there is already a key configured.


## Application of the main configuration

From the `ansible/` directory, run `ansible-playbook playbook.yaml`.
