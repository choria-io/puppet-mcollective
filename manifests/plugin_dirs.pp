class mcollective::plugin_dirs {
  $libdirs = $mcollective::plugintypes.map |$type| {
    "${mcollective::libdir}/mcollective/${type}"
  }

  if "aio_agent_version" in $facts and $facts["aio_agent_version"] =~ /^6/ {
    $extra_dirs = [
      "/etc/puppetlabs/mcollective",
      "/opt/puppetlabs/mcollective",
      "/opt/puppetlabs/mcollective/mcollective"
    ]
  } else {
    $extra_dirs = []
  }

  $needed_dirs = [
    "${mcollective::configdir}/plugin.d",
    "${mcollective::configdir}/policies",
    $mcollective::libdir,
    "${mcollective::libdir}/mcollective",
  ] + $libdirs + $extra_dirs

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
