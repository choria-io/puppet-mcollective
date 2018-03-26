Facter.add(:mcollective) do
  setcode do
    begin
      require "mcollective"

      result = {
        "version" => MCollective::VERSION,
        "client" => {},
        "server" => {}
      }

      ["client", "server"].each do |config|
        if MCollective::Util.windows?
          configfile = File.join(MCollective::Util.windows_prefix, "etc", "%s.cfg" % config)
        else
          [
            "/etc/puppetlabs/mcollective/%s.cfg",
            "/usr/local/etc/mcollective/%s.cfg",
            "/etc/mcollective/%s.cfg",
          ].each do |path|
            configfile = path % config
            break if File.exists?(configfile)
          end
        end

        mconfig = MCollective::Config.instance

        if File.readable?(configfile)
          MCollective::PluginManager.clear
          mconfig.set_config_defaults(configfile)
          mconfig.loadconfig(configfile)

          result[config]["libdir"] = mconfig.libdir.dup
          result[config]["connector"] = mconfig.connector.downcase
          result[config]["securityprovider"] = mconfig.securityprovider.downcase
          result[config]["collectives"] = mconfig.collectives
          result[config]["main_collective"] = mconfig.main_collective
        end
      end

      result
    rescue StandardError, LoadError
      {"error" => "%s: %s" % [$!.class, $!.to_s]}
    end
  end
end
