<?php

/**
 * Amend dovecot_impersonate to also use the IMAP login name for SMTP.
 *
 * @author     Einhard Leichtfuß
 * @copyright  2022 Einhard Leichtfuß
 * @license    https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html  GPL 2.0
 */

class dovecot_impersonate_smtp extends rcube_plugin
{
  public function init()
  {
    $this->require_plugin('dovecot_impersonate');
    $this->add_hook('smtp_connect', array($this, 'impersonate_smtp'));
  }


  function impersonate_smtp($data)
  {
    if(isset($_SESSION['plugin.dovecot_impersonate_master']))
    {
      $data['smtp_user'] .= $_SESSION['plugin.dovecot_impersonate_master'];
    }

    return($data);
  }
}
