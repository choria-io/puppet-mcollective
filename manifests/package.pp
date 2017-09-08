class mcollective::package {
  package{$mcollective::package_name:
    ensure => $mcollective::package_ensure,
  }
}
