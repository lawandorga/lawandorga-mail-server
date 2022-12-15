# A sample backup configuration.

# Notes:
#  * This name must be unique.
#    - The filename minus the .conf.bash suffix is usually a good idea.
#    - If this is changed, old backups must be deleted manually.
#  * This should not contain special characters that may cause problems.
#    - Notably, they should be valid in file names.
#      - The name is used in a tag, which is translated to a directory name
#        when using `restic mount`.
#      - Notably, `/` must not be used.
#    - [a-z0-9._+=-] seem fine.
scfg_NAME=sample

# Optional.  Default true.
scfg_LVM=true

# Required iff $scfg_LVM = true.
scfg_LVM_VG=main
scfg_LVM_LV=var

# Required iff $scfg_LVM = false.
scfg_NOLVM_BASE_PATH=/etc

scfg_RETENTION_DAYS=23

# This is optional.
#  - By default, the whole LV or base path is backed up, respectively.
scfg_RELATIVE_PATHS=(
  www
  lib/misc
)

# This is optional.
scfg_PRE()
{
  ...
}

# This is optional.
#  - Note that this is not executed in case an error occurs in the backup
#    process prior to reaching the step of calling this function.
scfg_POST()
{
  ...
}
