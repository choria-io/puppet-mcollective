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

  # some config settings are set directly on the main class, they are
  # things other classes need to function for example libdir is also
  # used by the plugin installer.  Specifically these settings should
  # never be overridden by settings from the hashes since any difference
  # between server/client cfg and what ends up being used by the plugin
  # installer will lead to plugins not being found.
  $global_config = {
    "libdir" => $mcollective::libdir
  }

  # These are overrides for the choria shim that we definitely do not want set or have
  # to set to specific values for whatever reason
  $shim_overrides = {
    "rpcaudit"        => "0",
    "logfile"         => "/var/log/choria-mcorpc.log",
    "collectives"     => "mcollective",
    "main_collective" => "mcollective",
    "daemonize"       => "0"
  }

  # The order of these are important:
  #
  # - common config is effectively defaults, overridable by specific server/client settings
  # - sub collective setup is derived from the class parameters, but should be overridable by server/client ccofig
  # - client_config and server_config has highest priority and overrules everything
  # - global config for things like libdir that are properties on the main class.  These should always take the main properties.
  $server_config = $mcollective::common_config + $server_collectives + $mcollective::server_config + $global_config
  $client_config = $mcollective::common_config + $client_collectives + $mcollective::client_config + $global_config

  mcollective::config_file{"${mcollective::configdir}/server.cfg":
    settings => $server_config,
    notify   => Class["mcollective::service"]
  }

  mcollective::config_file{"${mcollective::configdir}/client.cfg":
    settings => $client_config,
  }

  $temp_shim_config = $mcollective::common_config + $mcollective::server_config + $global_config + $shim_overrides
  $shim_config = ["plugin.rpcaudit.logfile", "registerinterval", "registration", "rpcauditprovider"].reduce($temp_shim_config) |$memo, $key| {
    $memo.delete($key)
  }

  mcollective::config_file{"${mcollective::configdir}/choria-shim.cfg":
    settings => $shim_config,
  }

  $policy_content = epp("mcollective/policy_file.epp", {
    "module"         => "rpcutil",
    "policy_default" => $mcollective::policy_default,
    "policies"       => $mcollective::rpcutil_policies,
    "site_policies"  => $mcollective::site_policies
  })

  file{"${mcollective::configdir}/policies/rpcutil.policy":
    owner   => $mcollective::plugin_owner,
    group   => $mcollective::plugin_group,
    mode    => $mcollective::plugin_mode,
    content => $policy_content,
    notify  => Class["mcollective::service"]
  }
}
