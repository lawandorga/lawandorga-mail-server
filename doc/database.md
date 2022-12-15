# Database setup (Scaleway specific)

We use an external database to store variable configuration such as mail
accounts and aliases.

We assume a (PostgreSQL) managed database server and the database to be used,
`lawandorga-backend`, have already been created at Scaleway.  These shall be
used in the following.

The database is set up as follows, via Scaleway.

1. Set up database access.
    1. Create database user `lawandorga-mail-server`.
    2. Give the `lawandorga-mail-server` user read-only access to
       `lawandorga-backend`.
2. Set up database tables via the [Law&Orga backend](https://github.com/lawandorga/lawandorga-backend-service).
3. Set up a private network.
    1. To the database server, add a new private network
       `lawandorga-mail-server-db`, with IP address `10.25.0.2/30`.
    2. Add the mail server to the private network.
    3. Adjust the Ansible configuration.
        1. Adjust the TCP port in [`hosts.yaml`](/ansible/hosts.yaml).
        2. Configure the `secret_database_password` variable as a
           [secret](/doc/ansible/secrets.md).


See also

* [the ansible `database-access` role](/ansible/roles/database-access/).
