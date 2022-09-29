# Configuration of environment variables.

We do not use `/etc/environment`, but `/etc/profile.d/environment.sh` with
`export` lines.

This requires that `/etc/profile` sources `/etc/profile.d/*`, which is usually
the case (and explicitly configured by us).


Reasoning:

* /etc/environment has a strange format.
    * The only documentation I am aware of is in `pam_env(7)` and
      `pam_env.conf(5)`.
        * Only says it contains "simple KEY=val pairs on separate lines".
    * Testing revealed (Debian machine, accessed via SSH+PAM, 2021-03-26):
        * Initial quotes on values (`'` or `"`) are stripped.
            * If initial quotes are present, final quotes are also stripped
              (don't need to match).
            * Final quotes without initial quotes are kept.
        * Everything after `#` is dropped, irrespective of whitespace.
          * E.g., `foo=bar#baz` is equivalent to `foo=bar`.
        * Invalid lines (e.g., missing `=`) are silently ignored (possibly
          logged?).
        * Leading spaces (before `KEY`) are dropped.
        * Non-leading spaces before `=` cause line to be ignored.
        * Spaces after `=` part of value, unless dropped by `#`.
* `/etc/environment` is only read by PAM.  E.g., SSH does by default not use
  PAM (but in must cases is configured otherwise).
* See also:
    * <https://serverfault.com/questions/506053/how-does-one-properly-escape-a-leading-character-in-linux-etc-environment>
    * <https://unix.stackexchange.com/questions/97736/escape-hash-mark-in-etc-environment>
