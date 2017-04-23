class mcollective::plugin_dirs {
  $libdirs = $mcollective::plugintypes.map |$type| {
    "${mcollective::libdir}/mcollective/${type}"
  }

  $needed_dirs = [
    "${mcollective::configdir}/plugin.d",
    "${mcollective::configdir}/policies",
    $mcollective::libdir,
    "${mcollective::libdir}/mcollective",
    $libdirs
  ]

  if $mcollective::purge {
    $purge_options = {
      source  => "puppet:///modules/mcollective/empty",
      ignore  => ".keep",
      purge   => true,
      recurse => true,
      force   => true
    }
  } else {
    $purge_options = {}
  }

  file {
    default:
      * =>  $purge_options;

    $needed_dirs:
      ensure => "directory",
      owner  => $mcollective::plugin_owner,
      group  => $mcollective::plugin_group,
      mode   => $mcollective::plugin_mode;
  }
}
