Manage a AIO Installation of The Marionette Collective
======================================================

This is an module to manage an already installed Puppet AIO based mcollective:

  * Configures the main `server.cfg` and `client.cfg` and service
  * Provides a mcollective plugin packager that produce AIO specific modules of mco plugins
  * Installs a number of default puppet related plugins
  * Creates directories the AIO packages failed to create

It's part of a larger effort to make bootstrapping trivial, to that goal a new Security
provider has been written for use with AIO Puppet when used with a Puppet CA, this can
be found at https://github.com/ripienaar/mcollective-security-puppet and is relased on
the forge at https://forge.puppet.com/ripienaar/mcollective_security_puppet

Configuring Server and Client
-----------------------------

Server and Client settings are managed using Hiera data and these keys are set up for deep
hash merging using look up strategies.

Some settings like the connector and security provider tend to be common to the Client and
Server, these are configured using Hiera:

```yaml
mcollective::common_config:
  securityprovider: puppet
```

This will result in both the main `server.cfg` and `client.cfg` having these settings.

Likewise client specific settings can be set with `mcollective::client_config` and
`mcollective::server_config`.

To enable a specific node to be a MCollective client you have to set `mcollective::client`
to `true` via hiera

Installing Plugins
------------------

By default plugins like the puppet, service, package agents and packager will be installed.
These are typically shipped as their own classes or modules and you can add to the list by
setting the following in hiera:

```yaml
mcollective::plugin_classes:
  - your::agent
```

Or you can just install them however you prefer.

Plugin Packaging
----------------

MCollective has a framework for packaging plugins, while this framework is a bit buggy
and old it's still useful for the common cases, this module provides a plugin to the
packager that lets you build AIO specific modules to install your agents.

It will be installed on all nodes that are set to install the client, to use it do something
like this:

```
$ cd your_agent
$ mco plugin package --format aiomodulepackage --vendor yourco
```

When you're done you'll have a new Puppet module called someting like `yourco-mcollective_agent_example`
that has a dependency on this module.

The resulting module is heavily customizable using Hiera, see the `README` in your module for details.
It will have a data file `data/plugin.yaml` full of file lists and such, you can mix in configuration,
dependencies and more by creating a file `.plugin.yaml` in your repo that might look like this:

```yaml
mcollective_agent_example::gem_dependencies:
  eventmachine:
    "1.0.7"

mcollective_agent_example::class_dependencies:
  - another::class

mcollective_agent_example::common_config:
  "some.setting": "config value"
```

This will be merged into the final module data and configure the resulting Puppet module based on
Puppet 4 data in modules.

Status
------

It's early days for this module and right now it only works with RedHat - or probably all Unix thanks
to the AIO standards.  Supporting other OSes is quite easy by adding files in `os/OsFamily.yaml`,
contributions appreciated.

I have a goal to make using files like `~/.mcollective` and the very complex nature of managing
those completely redundant.  So this module does nothing at present to help you manage those.  They
are INI files though so you can easily use `puppetlabs-inifile`, which this module use to manage the
main config files too.
