class mcollective::facts (
  String $libdir = $mcollective::libdir,
  String $rubypath = $mcollective::rubypath,
  String $configdir = $mcollective::configdir,
  String $factspath = $mcollective::factspath,
  Integer $refresh_interval = $mcollective::facts_refresh_interval,
  String $owner = $mcollective::plugin_owner,
  String $group = $mcollective::plugin_group,
  Boolean $server = $mcollective::server
) {
  $scriptpath = "${libdir}/refresh_facts.rb"

  file{$scriptpath:
    owner   => $owner,
    group   => $group,
    mode    => "0755",
    content => template("mcollective/refresh_facts.erb"),
  }

  if $server {
    exec{"mcollective_facts_yaml_refresh":
      command => "${scriptpath} -o ${factspath}",
    }
  }

  if $refresh_interval > 0 and $server {
    $cron_ensure = "present"
  } else {
    $cron_ensure = "absent"
  }

  if $facts["os"]["family"] == "windows" {
    scheduled_task{"mcollective_facts_yaml_refresh":
      ensure               => $cron_ensure,
      command              => $scriptpath,
      arguments            => "-o ${factspath}",
      trigger              => {
        "schedule"         => "daily",
        "start_time"       => "00:00",
        "minutes_interval" => $refresh_interval
      }
    }
  } else {
    cron{"mcollective_facts_yaml_refresh":
      ensure  => $cron_ensure,
      command => "${scriptpath} -o ${factspath}",
      minute  => "*/${refresh_interval}"
    }
  }
}
