# Setup of a basic Debian system

## Goal

The goal is to set up a Debian system that is minimal, while being configured
to the point that

* a) Ansible can do its work,
* b) all configuration that cannot (easily) be done via Ansible is done.

More precisely, the goal is a minimal Debian system, with

* the [disks fully set up](/doc/disks.md),
* a decent SSH setup,
    - This must be compatible with that installed by Ansible.
* a basic firewall.


## Setup

We currently use Scaleway as provider, so there is some documentation specific
to that provider.

The process is as follows:

1. [Setup VM (Scaleway)](/doc/setup/vm-scaleway.md)
2. [Setup disks](/doc/disks.md)
3. [Install Debian](/doc/setup/debian.md)
4. [Remove remnants of initial bootstrap system (Scaleway)](/doc/setup/vm-scaleway/remove-boostrap-volume.md)
