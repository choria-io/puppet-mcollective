class mcollective::facts (
  String $libdir = $mcollective::libdir,
  String $rubypath = $mcollective::rubypath,
  String $configdir = $mcollective::configdir,
  String $factspath = $mcollective::factspath,
  Integer $refresh_interval = $mcollective::facts_refresh_interval,
  Optional[String] $owner = $mcollective::plugin_owner,
  Optional[String] $group = $mcollective::plugin_group,
  Optional[String] $pidfile = $mcollective::facts_pidfile,
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
    $cron_offset = "00:${sprintf("%02d", fqdn_rand($refresh_interval, 'facts cronjob'))}"
    $cron_minutes = mcollective::crontimes(fqdn_rand($refresh_interval, 'facts cronjob'), $refresh_interval, 60)
    $creates = $factspath

    exec{"mcollective_facts_yaml_refresh":
      command => "\"${rubypath}\" \"${scriptpath}\" -o \"${factspath}\"",
      creates => $creates,
      require => Class["mcollective::service"]
    }
  } else {
    $cron_ensure = "absent"
    $cron_offset = "00:00"
    $cron_minutes = "0"
    $creates = undef # always run via puppet when opted out of cron option
  }

  if $pidfile {
    $factspid = "-p '${pidfile}'"
  }

  if $facts["os"]["family"] == "windows" {
    # on windows task scheduler prevent dupes already so no need to handle the PID here
    scheduled_task{"mcollective_facts_yaml_refresh":
      ensure    => $cron_ensure,
      command   => $rubypath,
      arguments => "'${scriptpath}' -o '${factspath}'",
      trigger   => {
        "schedule"         => "daily",
        "start_time"       => $cron_offset,
        "minutes_interval" => $refresh_interval
      }
    }
  } else {
    cron{"mcollective_facts_yaml_refresh":
      ensure  => $cron_ensure,
      command => "'${rubypath}' '${scriptpath}' -o '${factspath}' ${factspid}",
      minute  => $cron_minutes
    }
  }
}
