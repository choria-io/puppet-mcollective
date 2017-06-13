# Utility to create mcollective config files
#
# @param settings hash of settings to add via ini_setting
# @param owner File ownership - only used when content is set
# @param group File group ownership - only used when content is set
# @param mode File mode - only used when content is set
# @param content When set manages the entire file
define mcollective::config_file (
  Hash $settings = {},
  Optional[String] $owner = $mcollective::plugin_owner,
  Optional[String] $group = $mcollective::plugin_group,
  Optional[String] $mode = $mcollective::plugin_mode,
  Optional[String] $content = undef,
  Enum["present", "absent"] $ensure = "present"
) {
  if $content {
    $body = $content
  } else {
    $body = mcollective::hash2config($settings)
  }
  file{$name:
    owner   => $owner,
    group   => $group,
    mode    => $mode,
    content => $body,
    ensure  => $ensure
  }
}
