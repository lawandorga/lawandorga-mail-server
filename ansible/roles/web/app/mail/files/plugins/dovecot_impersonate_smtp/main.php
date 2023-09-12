<?php

/**
 * Amend dovecot_impersonate to also use the IMAP login name for SMTP.
 *
 * @author     Einhard Leichtfuß
 * @copyright  2022, 2023 Einhard Leichtfuß
 * @license    https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html  GPL 2.0
 */

class dovecot_impersonate_smtp extends rcube_plugin
{
  private $rc;


  public function init()
  {
    $this->require_plugin('dovecot_impersonate');
    $this->add_hook('smtp_connect', array($this, 'impersonate_smtp'));

    $this->rc = rcube::get_instance();
  }


  function impersonate_smtp($data)
  {
    if(isset($_SESSION['plugin.dovecot_impersonate_master']))
    {
      // See
      // `/usr/share/roundcube/program/lib/Roundcube/rcube_smtp.php#connect()`.
      if ($data['smtp_user'] == '%u')
      {
        $data['smtp_user'] = (string) $this->rc->get_user_name();
      }

      $data['smtp_user'] .= $_SESSION['plugin.dovecot_impersonate_master'];
    }

    return($data);
  }
}
