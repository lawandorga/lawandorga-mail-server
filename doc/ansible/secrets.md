# Ansible secrets

* Secret values such as passwords are not tracked via git.
* Instead, they are to be written to a
  [`secrets.yaml`](/ansible/host_vars/lawandorga-mail-server/secrets.yaml)
  file, that has to be filled manually.
    * Other locations for such a `secrets.yaml` file, such as within
      `/ansible/group_vars/*`, are fine.
        * See `.gitignore` below.
* A [`.gitignore`](/.gitignore) file provides a little protection against
  accidental publication of this file via git.
    * The `.gitignore` file matches all files named `secrets.yaml`, anywhere.
* It may be useful to use the `!unsafe` keyword when providing secrets
  containing special characters.


## Specific secrets

For specific secrets to be written to the
[`secrets.yaml`](/ansible/host_vars/lawandorga-mail-server/secrets.yaml) file,
see

* [database setup](/doc/database.md),
* [backup setup](/doc/ansible/secrets/backup.md).


## Alternatives

Alternative ways of sharing secrets might be *Ansible Vault* or *git-crypt*.
These should be analyzed for their security within the context of a publicly
accessible git repository prior to their use.
