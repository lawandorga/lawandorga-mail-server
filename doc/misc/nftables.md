# Notes on nftables configuration

## Avoid `iif`, `oif`

* Instead, use `iifname`, `oifname`.
* Exception: the `lo` interface.
* Reason: An nftables script will fail if the specified interface does not
  exist.
    * In the case of the main nftables script, this means that the nftables
      firewall will be effectively inactive after booting.
    * We have seen an interface name change on a Scaleway VM.
        * This was on changing the network setup from "NAT public IP" to the
          new "routed public IP".
