class mcollective::config {
  $server_config = $mcollective::common_config + $mcollective::server_config
  $client_config = $mcollective::common_config + $mcollective::client_config

  $server_config.each |$item, $value| {
    ini_setting{"${name}_server_${item}":
      path    => "/etc/puppetlabs/mcollective/server.cfg",
      setting => $item,
      value   => $value,
      notify  => Class["mcollective::service"]
    }
  }

  $client_config.each |$item, $value| {
    ini_setting{"${name}_client_${item}":
      path    => "/etc/puppetlabs/mcollective/client.cfg",
      setting => $item,
      value   => $value
    }
  }
}
