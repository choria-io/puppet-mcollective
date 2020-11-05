# Manage AIO based Marionette Collective
#
# @param plugintypes The list of plugin directories to create under libdir
# @param plugin_classes The list of plugins to install via classes
# @param plugin_classes_exclude A list of plugins not to install
# @param server_config A hash of config items to set in the server.cfg
# @param client_config A hash of config items to set in the client.cfg
# @param common_config A hash of config items to set in both client.cfg and server.cfg
# @param bindir Where to create symlinks for our commands
# @param libdir The directory where plugins will go in
# @param configdir Root directory to config files
# @param facts_refresh_interval Minutes between fact refreshes, set to 0 to disable cron based refreshes
# @param rubypath Path to the ruby executable
# @param collectives A list of collectives the node belongs to
# @param client_collectives A list of collectives the client has access to, defaults to the same as the node
# @param main_collective The main collective to use, last in the list of `$collectives` by default
# @param client_main_collective The main collective to use on the client, `$main_collective` by default
# @param facts_pidfile PID file path for locking fact refresh to a single execution
# @param plugin_owner The default user who will own plugin files
# @param plugin_group The default group who will own plugin files
# @param plugin_mode The default mode plugin files will have
# @param plugin_executable_mode The default mode executable plugin files will have
# @param required_directories Any extra directories that should be created before copying plugins and configuration
# @param policy_default When managing plugin policies this will be the default allow/deny
# @param site_policies Policies to apply to all agents after any module specific policies
# @param rpcutil_policies Policies to apply to the special rpcutil agent
# @param choria_util_policies Policies to apply to the special choria_util agent
# @param scout_policies Policies to apply to the special scout agent
# @param manage_package Install mcollective package on this node
# @param package_name The name of the package to install if manage_package is enabled
# @param package_ensure Ensure value for the package
# @param service_ensure Ensure value for the service
# @param service_name The mcollective service name to notify and manage
# @param service_enable The enable value for the service
# @param client Install client files on this node
# @param server Install server files on this node
# @param purge When true will remove unmanaged files from the $configdir/plugin.d, $configdir/policies and $libdir
# @param gem_source where to find gems, useful for local gem mirrors
# @param manage_bin_symlinks Enables creating symlinks in the bin dir for the mco command
# @param file_transfer_type enum to configure global type for file resources in plugins. could be overwritten for every plugin in their defined resource
class mcollective (
  Array[String[1]] $plugintypes,
  Array[String[1]] $plugin_classes,
  Array[String[1]] $plugin_classes_exclude = [],
  Hash $server_config = {},
  Hash $client_config = {},
  Hash $common_config = {},
  Stdlib::Absolutepath $bindir,
  Stdlib::Absolutepath $libdir,
  Stdlib::Absolutepath $configdir,
  Stdlib::Absolutepath $rubypath,
  Boolean $manage_bin_symlinks = false,
  Integer $facts_refresh_interval,
  Array[Mcollective::Collective] $collectives,
  Array[Mcollective::Collective] $client_collectives = $collectives,
  Optional[Mcollective::Collective] $main_collective = undef,
  Optional[Mcollective::Collective] $client_main_collective = undef,
  Optional[Stdlib::Absolutepath] $facts_pidfile,
  Optional[String[1]] $plugin_owner,
  Optional[String[1]] $plugin_group,
  Optional[Stdlib::Filemode] $plugin_mode,
  Optional[Stdlib::Filemode] $plugin_executable_mode,
  Array[Stdlib::Absolutepath] $required_directories = [],
  Mcollective::Policy_action $policy_default,
  Array[Mcollective::Policy] $site_policies = [],
  Array[Mcollective::Policy] $rpcutil_policies = [],
  Array[Mcollective::Policy] $choria_util_policies = [],
  Array[Mcollective::Policy] $scout_policies = [],
  Stdlib::Filesource $default_rego_policy_source,
  Boolean $manage_package,
  Enum["present", "latest"] $package_ensure,
  String[1] $package_name,
  Enum["stopped", "running"] $service_ensure,
  String[1] $service_name,
  Boolean $service_enable,
  Boolean $client,
  Boolean $server,
  Boolean $purge,
  Optional[String[1]] $gem_source = undef,
  String[1] $gem_provider
  Enum['content', 'source'] $file_transfer_type = 'source',
) {
  $factspath = "${configdir}/generated-facts.yaml"

  if $mcollective::manage_package {
    contain mcollective::package
  }
  contain mcollective::plugin_dirs
  contain mcollective::config
  contain mcollective::facts
  contain mcollective::service

  contain $plugin_classes - $plugin_classes_exclude
}
