# Removal of the initial bootstrap "volume"

Once the installation is complete and confirmed working, the "volume"
containing the Scaleway-provided Debian image can safely be removed as follows:

* Turn off the VM (`halt -p`, then switch off via web interface (or API/CLI)).
* "Instances" -> INSTANCE-NAME -> "Attached Volumes" -> VOLUME-NAME
  -> "Delete"
* Power the VM on again (via web interface / API / CLI).
