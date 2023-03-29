<?php

/**
 * Add extra links to the login page.
 *
 * @author     Einhard Leichtfuß
 * @copyright  2023 Einhard Leichtfuß
 * @license    https://www.gnu.org/licenses/agpl-3.0.html  AGPL 3.0 or later
 */

class login_page_extra_links extends rcube_plugin
{
  private $rc;

  function init()
  {
    $this->rc = rcube::get_instance();
    $this->load_config();

    $items = $this->rc->config->get('login_page_extra_links', array());

    $sep = $this->rc->config->get
      ( 'login_page_extra_links_separator'
      , ' &nbsp;&bull;&nbsp;&nbsp;'
      );

    foreach ($items as $item)
    {
      $this->api->add_content
        (   $sep
          . '<a href="' . $item['url'] . '" target="_blank">'
          . $item['label']
          . '</a>'
        , 'loginfooter'
        );
    }
  }
}
