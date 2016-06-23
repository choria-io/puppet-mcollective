class mcollective::packager {
  mcollective::module_plugin{$name:
    config_name                 => "aiopackager",
    client_files                => [
      "pluginpackager/templates/aiomodule/manifests/init.pp.erb",
      "pluginpackager/templates/aiomodule/data/plugin.yaml.erb",
      "pluginpackager/templates/aiomodule/data/defaults.yaml.erb",
      "pluginpackager/templates/aiomodule/metadata.json.erb",
      "pluginpackager/templates/aiomodule/hiera.yaml.erb",
      "pluginpackager/templates/aiomodule/README.md.erb",
      "pluginpackager/aiomodulepackage_packager.rb"
    ],
    client_directories          => [
      "pluginpackager",
      "pluginpackager/templates",
      "pluginpackager/templates/aiomodule",
      "pluginpackager/templates/aiomodule/manifests",
      "pluginpackager/templates/aiomodule/data"
    ]
  }
}
