# Database setup (Scaleway specific)

We use an external database to store variable configuration such as mail
accounts and aliases.

We assume a (PostgreSQL) managed database has already been created at
Scaleway.  It shall be used in the following.

The database is set up as follows, via Scaleway.

1. Setup database.
    1. Create database `lawandorga-mail-server`.
    2. Create database user `lawandorga-mail-server`.
    3. Give [lawandorga-backend-service](https://github.com/lawandorga/lawandorga-backend-service)'s
       user read-write access to `lawandorga-mail-server`.
    4. Give the `lawandorga-mail-server` user read-only access to
       `lawandorga-mail-server`.
2. Populate the database via the [Law&Orga backend](https://github.com/lawandorga/lawandorga-backend-service).
3. Set up a private network.
    1. To the database server, add a new private network
       `lawandorga-mail-server-db`, with IP address `10.25.0.2/30`.
    2. Add the mail server to the private network.
    3. Adjust the Ansible configuration.
        1. Adjust the TCP port in [`hosts.yaml`](/ansible/hosts.yaml).
        2. Set the `secret_database_password` variable in
           [`secrets.yaml`](/ansible/host_vars/lawandorga-mail-server/secrets.yaml).
            * This file is, for obvious reasons, not tracked via git.
                * See also the [`.gitignore`](/.gitignore) file.


See also

* [the ansible `database-access` role](/ansible/roles/database-access/).
