define mcollective::module_plugin (
  String $config_name,
  Array[String] $client_files = [],
  Array[String] $client_directories = [],
  Array[String] $server_files = [],
  Array[String] $server_directories = [],
  Array[String] $common_files = [],
  Array[String] $common_directories = [],
  Boolean $manage_gem_dependencies = true,
  Hash $gem_dependencies = {},
  Boolean $manage_package_dependencies = true,
  Hash $package_dependencies = {},
  Boolean $manage_class_dependencies = true,
  Array[String] $class_dependencies = [],
  Mcollective::Policy_action $policy_default = $mcollective::policy_default,
  Array[Mcollective::Policy] $policies = [],
  Array[Mcollective::Policy] $site_policies = $mcollective::site_policies,
  Hash $config = {},
  Hash $client_config = {},
  Hash $server_config = {},
  Boolean $client = $mcollective::client,
  Boolean $server = $mcollective::server,
  String $libdir = $mcollective::libdir,
  String $configdir = $mcollective::configdir,
  Optional[String] $owner = $mcollective::plugin_owner,
  Optional[String] $group = $mcollective::plugin_group,
  Optional[String] $mode = $mcollective::plugin_mode,
  Enum["present", "absent"] $ensure = "present",
  Boolean $activate_agent = true,
  Boolean $activate_client = true
) {
  $_agent = $name =~ /^mcollective_agent_/

  if $client or $server {
    if ($server and $client) {
      $activate_config = $_agent ? {true => {"activate_agent" => $activate_agent, "activate_client" => $activate_client}, false => {}}
      $merged_conf = $config.deep_merge($client_config).deep_merge($server_config) + $activate_config
      $merged_files = $common_files + $server_files + $client_files
      $merged_directories = $common_directories + $server_directories + $client_directories

    } elsif ($server) {
      $activate_config = $_agent ? {true => {"activate_agent" => $activate_agent, "activate_client" => false}, false => {}}
      $merged_conf = $config.deep_merge($server_config) + $activate_config
      $merged_files = $common_files + $server_files
      $merged_directories = $common_directories + $server_directories

    } elsif ($client) {
      $activate_config = $_agent ? {true => {"activate_agent" => false, "activate_client" => $activate_client}, false => {}}
      $merged_conf = $config.deep_merge($client_config) + $activate_config
      $merged_files = $common_files + $client_files
      $merged_directories = $common_directories + $client_directories
    }

    if $manage_class_dependencies and !$class_dependencies.empty {
      require $class_dependencies
    }

    if $manage_package_dependencies {
      $package_dependencies.each |$pkg, $version| {
        package{$pkg:
          ensure => $version,
          tag    => "mcollective_plugin_${name}_packages"
        }
      }
    }

    if $manage_gem_dependencies {
      $gem_dependencies.each |$gem, $version| {
        package{$gem:
          ensure          => $version,
          provider        => $mcollective::gem_provider,
          source          => $mcollective::gem_source,
          install_options => $mcollective::gem_install_options,
          tag             => "mcollective_plugin_${name}_packages"
        }
      }
    }

    if $name =~ /^mcollective_agent_(.+)/ and $server {
      $agent_name = $1

      $policy_content = epp("mcollective/policy_file.epp", {
        "module"         => $name,
        "policy_default" => $policy_default,
        "policies"       => $policies,
        "site_policies"  => $site_policies
      })

      file{"${configdir}/policies/${agent_name}.policy":
        owner   => $owner,
        group   => $group,
        mode    => $mode,
        content => $policy_content
      }

      Package <| tag == "mcollective_plugin_${name}_packages" |> -> File["${configdir}/policies/${agent_name}.policy"]
    }

    unless $merged_conf.empty {
      # the bolt agent and main choria coded both use choria as plugin name which breaks this
      # we have to fix that when moving to the new model for distributing plugins for now
      # this is the only way
      unless defined(Mcollective::Config_file["${configdir}/plugin.d/${config_name}.cfg"]) {
        mcollective::config_file{"${configdir}/plugin.d/${config_name}.cfg":
          ensure   => $ensure,
          settings => $merged_conf,
          owner    => $owner,
          group    => $group,
          mode     => $mode
        }
      }
    }

    $merged_directories.each |$file| {
      unless defined(File["${libdir}/mcollective/${file}"]) {
        file{"${libdir}/mcollective/${file}":
          ensure  => $ensure ? {"present" => "directory", "absent" => "absent"},
          owner   => $owner,
          group   => $group,
          mode    => $mode,
        }

        Package <| tag == "mcollective_plugin_${name}_packages" |> -> File["${libdir}/mcollective/${file}"]
      }
    }

    $merged_files.each |$file| {
      if $file =~ /agent\/([^\/]+).rb/ {
        $f_tag = "mcollective_agent_${1}_server"
      } else {
        $f_tag = undef
      }

      file{"${libdir}/mcollective/${file}":
        ensure => $ensure,
        source => "puppet:///modules/${caller_module_name}/mcollective/${file}",
        owner  => $owner,
        group  => $group,
        mode   => $mode,
        tag    => $f_tag
      }

      Package <| tag == "mcollective_plugin_${name}_packages" |> -> File["${libdir}/mcollective/${file}"]
    }

    Mcollective::Module_plugin[$name] ~> Class["mcollective::service"]
  }
}
