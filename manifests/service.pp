class mcollective::service {
  service{$mcollective::service_name:
    ensure => $mcollective::service_ensure,
    enable => $mcollective::service_enable
  }
}
