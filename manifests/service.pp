class mcollective::service {
  if "aio_agent_version" in $facts and $facts["aio_agent_version"] =~ /^6/ {
    return()
  }

  service{$mcollective::service_name:
    ensure => $mcollective::service_ensure,
    enable => $mcollective::service_enable
  }
}
