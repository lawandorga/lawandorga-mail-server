#!/usr/bin/env bash

# Update/install the root trust anchor available to unbound from that provided
# by the `dns-root-data' package--when necessary.
#  - Only install, when unbound's current root key is missing or older (by
#    timestamp).
#  - The trust anchor file must be located in a directory writable by
#    unbound; see also `/etc/unbound/unbound.conf'.
#  - This is pretty much what
#      `/usr/lib/unbound/package-helper root_trust_anchor_update'
#    does.
#    - This would need ROOT_TRUST_ANCHOR_FILE to be set appropriately in
#      `/etc/default/unbound`.
#      - See
#        - `/usr/lib/unbound/package-helper`,
#        - `/usr/share/doc/unbound/NEWS.Debian.gz`.


typeset -r src='/usr/share/dns/root.key'
typeset -r tgt='/var/lib/unbound/root_key/root.key'


if [[ ! -e "$src" || "$src" -nt "$tgt" ]]
then
	printf 'Installing/updating root trust anchor.\n'
	install -m 0644 -o unbound -g unbound "$src" "$tgt"
fi
