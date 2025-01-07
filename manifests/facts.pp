class mcollective::facts (
  String $libdir = $mcollective::libdir,
  String $rubypath = $mcollective::rubypath,
  String $configdir = $mcollective::configdir,
  String $factspath = $mcollective::factspath,
  Optional[Enum['cron', 'systemd']] $refresh_type = $mcollective::facts_refresh_type,
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
    mode    => "0775",
    content => template("mcollective/refresh_facts.erb"),
  }

  if $refresh_interval > 0 and $server {
    if $facts["systemd"] == true and $refresh_type == "systemd" {
      $cron_ensure = "absent"
      $systemd_ensure = "present"
      $systemd_active = true
      $systemd_enable = true
    } else {
      $cron_ensure = "present"
      $systemd_ensure = "absent"
      $systemd_active = false
      $systemd_enable = false
    }
    $cron_offset = "00:${sprintf("%02d", fqdn_rand($refresh_interval, 'facts cronjob'))}"
    $cron_minutes = mcollective::crontimes(fqdn_rand($refresh_interval, 'facts cronjob'), $refresh_interval, 60)
    $timer_on_calendar = "*:${cron_minutes.join(',')}"
    $creates = $factspath

    exec{"mcollective_facts_yaml_refresh":
      command => "\"${rubypath}\" \"${scriptpath}\" -o \"${factspath}\"",
      creates => $creates,
      require => Class["mcollective::config"]
    }
  } else {
    $cron_ensure = "absent"
    $systemd_ensure = "absent"
    $systemd_active = false
    $systemd_enable = false
    $cron_offset = "00:00"
    $cron_minutes = "0"
    $timer_on_calendar = "*:0"
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
      command => "'${rubypath}' '${scriptpath}' -o '${factspath}' ${factspid} &> /dev/null",
      minute  => $cron_minutes
    }
    if $facts["systemd"] == true {
      systemd::timer { "mcollective-facts-refresh.timer":
        ensure          => $systemd_ensure,
        active          => $systemd_active,
        enable          => $systemd_enable,
        timer_content   => epp("mcollective/refresh_facts.timer.epp", {
          "oncalendar" => $timer_on_calendar,
        }),
        service_content => epp("mcollective/refresh_facts.service.epp", {
          "rubypath"   => $rubypath,
          "scriptpath" => $scriptpath,
          "factspath"  => $factspath,
          "pidfile"    => $pidfile,
        }),
      }
    }
  }
}
