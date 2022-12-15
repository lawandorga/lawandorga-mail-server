# Configure backup secrets

See the [`backup`](/ansible/roles/backup/) role for general information on the
backup process.


## Restic password

* `secret_backup_restic_password`
    * The restic password is known by those who need to know it.
    * It should be changed when this set of people changes.


## S3 access

* We store our backups in S3.
* *Scaleway-specific:*
    * Generate a pair of API keys in the
      [Scaleway web interface](https://console.scaleway.com/project/credentials).
    * The API keys are not crucial for access to the data; i.e., they do not
      need backing up and can be replaced at any time (assuming access to the
      Scaleway account).
* Configure access keys:
    * `secret_s3_access_key`
    * `secret_s3_secret_key`
