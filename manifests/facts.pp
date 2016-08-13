class mcollective::facts (
  String $libdir = $mcollective::libdir,
  String $rubypath = $mcollective::rubypath,
  String $configdir = $mcollective::configdir,
  String $factspath = $mcollective::factspath,
  Integer $refresh_interval = $mcollective::facts_refresh_interval,
  Optional[String] $owner = $mcollective::plugin_owner,
  Optional[String] $group = $mcollective::plugin_group,
  Boolean $server = $mcollective::server
) {
  $scriptpath = "${libdir}/mcollective/refresh_facts.rb"

  file{$scriptpath:
    owner   => $owner,
    group   => $group,
    mode    => "0755",
    content => template("mcollective/refresh_facts.erb"),
  }

  if $refresh_interval > 0 and $server {
    $cron_ensure = "present"
    $creates = $factspath
  } else {
    $cron_ensure = "absent"
    $creates = undef # always run via puppet when opted out of cron option
  }

  if $server {
    exec{"mcollective_facts_yaml_refresh":
      command => "\"${rubypath}\" \"${scriptpath}\" -o \"${factspath}\"",
      creates => $creates
    }
  }

  if $facts["os"]["family"] == "windows" {
    scheduled_task{"mcollective_facts_yaml_refresh":
      ensure               => $cron_ensure,
      command              => $rubypath,
      arguments            => "'${scriptpath}' -o '${factspath}'",
      trigger              => {
        "schedule"         => "daily",
        "start_time"       => "00:00",
        "minutes_interval" => $refresh_interval
      }
    }
  } else {
    cron{"mcollective_facts_yaml_refresh":
      ensure  => $cron_ensure,
      command => "'${rubypath}' '${scriptpath}' -o '${factspath}'",
      minute  => "*/${refresh_interval}"
    }
  }
}
