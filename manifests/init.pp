class mcollective (
  Array[String] $plugintypes,
  Array[String] $plugin_classes,
  Array[String] $plugin_classes_exclude = [],
  Hash $server_config = {},
  Hash $client_config = {},
  Hash $common_config = {},
  String $libdir,
  String $plugin_owner,
  String $plugin_group,
  String $plugin_mode,
  String $service_name,
  Enum["stopped", "running"] $service_ensure,
  Boolean $service_enable,
  Boolean $client,
  Boolean $server
) {
  include mcollective::plugin_dirs
  include mcollective::config
  include mcollective::service

  include $plugin_classes - $plugin_classes_exclude
}

