#!/usr/bin/env bash

# Update/install the root trust anchor available to unbound from that provided
# by the `dns-root-data' package--when necessary.
#  - Only install, when unbound's current root key is missing or older (by
#    timestamp).
#  - This is pretty much what
#      `/usr/lib/unbound/package-helper root_trust_anchor_update'
#    does, except it assumes a fixed target path--one that we cannot use.
#    - The trust anchor file must be located in a directory writable by
#      unbound; see also `/etc/unbound/unbound.conf'.


typeset -r src='/usr/share/dns/root.key'
typeset -r tgt='/var/lib/unbound/root_key/root.key'


if [[ ! -e "$src" || "$src" -nt "$tgt" ]]
then
	printf 'Installing/updating root trust anchor.\n'
	install -m 0644 -o unbound -g unbound "$src" "$tgt"
fi
