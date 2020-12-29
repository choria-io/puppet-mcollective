class mcollective::package {
  if $mcollective::package_name {
    package{$mcollective::package_name:
      ensure   => $mcollective::package_ensure,
      provider => $mcollective::package_provider,
    }
  }
}
