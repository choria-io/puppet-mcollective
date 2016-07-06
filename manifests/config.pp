class mcollective::config {
  $server_config = $mcollective::common_config + $mcollective::server_config
  $client_config = $mcollective::common_config + $mcollective::client_config

  if $mcollective::main_collective {
    $main_collective = $mcollective::main_collective
  } else {
    $main_collective = $mcollective::collectives[-1]
  }

  ["server", "client"].each |$cfg| {
    ini_setting{"${name}_${cfg}_main_collective":
      path    => "${mcollective::configdir}/${cfg}.cfg",
      setting => "main_collective",
      value   => $main_collective,
      notify  => Class["mcollective::service"]
    }

    ini_setting{"${name}_${cfg}_collectives":
      path    => "${mcollective::configdir}/${cfg}.cfg",
      setting => "collectives",
      value   => $mcollective::collectives.join(","),
      notify  => Class["mcollective::service"]
    }
  }

  $server_config.each |$item, $value| {
    ini_setting{"${name}_server_${item}":
      path    => "${mcollective::configdir}/server.cfg",
      setting => $item,
      value   => $value,
      notify  => Class["mcollective::service"]
    }
  }

  $client_config.each |$item, $value| {
    ini_setting{"${name}_client_${item}":
      path    => "${mcollective::configdir}/client.cfg",
      setting => $item,
      value   => $value
    }
  }
}
