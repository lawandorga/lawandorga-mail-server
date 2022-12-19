# Overview

The mail server is set up as follows.

1. [Setup of a basic Debian server, with SSH access.](/doc/setup.md)
2. [A database for the mail system is set up.](/doc/database.md)
3. [The DNS records are configured.](/doc/dns.md)
    * It may be a good idea to delay (parts of) this until after the next step.
        * Notably, any `MX` or DMARC `TXT` records should possibly be left at
          their former setting.
        * However, omitting DKIM `TXT` records will result in signatures with
          an unconfigured key, which may be deemed bad \[by recipients\].
4. [The mail server is fully configured using Ansible.](/doc/ansible.md)
