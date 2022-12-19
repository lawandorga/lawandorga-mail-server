# SPF records

* `TXT` record:
    * key: `spf.<MAILSERVER_DOMAIN>`
    * value: `v=spf1 ip4:<MAILSERVER_IPv4_ADDRESS> -all`
* `TXT` record:
    * key: `<CLIENT_DOMAIN>`
    * value:
        * simple: `v=spf1 include:spf.<MAILSERVER_DOMAIN> -all`
        * allowed: any valid SPF TXT record matching the following regex:
            * `^v=spf1 +(.+ +)?include:spf.<MAILSERVER_DOMAIN> +(.+ +)?-all$`
