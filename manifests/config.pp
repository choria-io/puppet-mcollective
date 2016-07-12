class mcollective::config {
  if $mcollective::main_collective {
    $main_collective = $mcollective::main_collective
  } else {
    $main_collective = $mcollective::collectives[-1]
  }

  if $mcollective::client_main_collective {
    $client_main_collective = $mcollective::client_main_collective
  } else {
    $client_main_collective = $main_collective
  }

  $client_collectives = {
    "collectives"     => $mcollective::client_collectives.join(","),
    "main_collective" => $client_main_collective
  }

  $server_collectives = {
    "collectives"     => $mcollective::collectives.join(","),
    "main_collective" => $main_collective
  }

  # The order of these are important:
  #
  # - common config is effectively defaults, overridable by specific server/client settings
  # - sub collective setup is derived from the class parameters, but should be overridable by server/client ccofig
  # - client_config and server_config has highest priority and overrules everything
  $server_config = $mcollective::common_config + $server_collectives + $mcollective::server_config
  $client_config = $mcollective::common_config + $client_collectives + $mcollective::client_config

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

  $policy_content = epp("mcollective/policy_file.epp", {
    "module"         => "rpcutil",
    "policy_default" => $mcollective::policy_default,
    "policies"       => $mcollective::rpcutil_policies,
    "site_policies"  => $mcollective::site_policies
  })

  file{"${mcollective::configdir}/policies/rpcutil.policy":
    owner      => $mcollective::plugin_owner,
    group      => $mcollective::plugin_group,
    mode       => $mcollective::plugin_mode,
    content    => $policy_content
  }
}
