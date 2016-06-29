class mcollective::plugin_dirs {
  $libdirs = $mcollective::plugintypes.map |$type| {
    "${mcollective::libdir}/${type}"
  }

  $needed_dirs = [
    "${mcollective::configdir}/plugin.d",
    $mcollective::libdir,
    $libdirs
  ]

  file{$needed_dirs:
    ensure => "directory",
    owner  => $mcollective::plugin_owner,
    group  => $mcollective::plugin_group,
    mode   => $mcollective::plugin_mode
  }
}
