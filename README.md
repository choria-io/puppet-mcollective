Manage a AIO Installation of The Marionette Collective
======================================================

This is an module to manage an already installed Puppet AIO based mcollective:

  * Configures the main `server.cfg` and `client.cfg` and service
  * Provides a mcollective plugin packager that produce AIO specific modules of mco plugins
  * Creates directories the AIO packages failed to create
  * [Puppet Agent](https://github.com/puppetlabs/mcollective-puppet-agent)
  * [Package Agent](https://github.com/puppetlabs/mcollective-package-agent)
  * [Service Agent](https://github.com/puppetlabs/mcollective-service-agent)
  * [File Manager Agent](https://github.com/puppetlabs/mcollective-filemgr-agent)
  * [Puppet Based Security System](https://github.com/ripienaar/mcollective-security-puppet) with default secure settings
  * [NATS.io Based Connector](https://github.com/ripienaar/mcollective-connector-nats) with default secure settings
  * [Action Policy Authorization](https://github.com/puppetlabs/mcollective-actionpolicy-auth) with default secure settings
  * Audit logs in `/var/log/mcollective-audit.log` and `C:/ProgramData/PuppetLabs/mcollective/var/log/mcollective-audit.log`
  * Facts using a YAML file refreshed using Cron or Windows Scheduler

It's part of a larger effort to make bootstrapping trivial, so this is effectively a
distribution of MCollective that pulls together various MCollective plugins to yield
a featureful and secure MCollective out of the box with minimal effort.

Installation
------------

You must have a AIO Puppet setup to communicate with a Puppet Master and it should already
have certs, by convention certs sould match `fqdn`.  The new security plugins require these
certs.

You need a middleware connector, this sets up a NATS.io based connector and does not configure
the middleware for you.  See the nodes in [NATS.md](NATS.md) for simple instructions to set
up NATS.

Once you have a connector install the `ripienaar-mcollective` module in your environment, it will
bring in all it's dependencies.

On a managed node include `mcollective`.

On a managed node that should also have client tools set `mcollective::client` to `true`. Set
`mcollective::server` to `false` to not maange the mcollective daemon or install any agents

Clients who wish to use the `mco` cli need a Puppet CA provided certificate, you obtain these
with:

```
$ mco request_cert -ca ca.example.net
```

Once the certificate is signed and downloaded you can use the utilities.  If fetching the cert
times out, you can just run this command again.

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

If for any reason you do not want some plugin on a tier, add it to the list `mcollective::plugin_classes_exclude`

Facts
-----

The only supported fact source is YAML and it will refresh on every Puppet run and by default
from Cron and Windows Scheduler.

Set `mcollective::facts_refresh_interval` to `0` to disable the scheduled updates.  At present
the output path cannot be changed and by default it will configure the daemon to the same path.

You can adjust the path to include additional YAML files if you wish by updating it to consider
multiple YAML files by specifying a `File::PATH_SEPARATOR` seperated list of paths.

Authorization
-------------

Authorization using the `actionpolicy` plugin is setup automatically and configured to default
deny all requests made from clients.

Agent plugins can declare their own default rule sets - which should allow non destructive
actions by default. For example the `service` agent should allow `status` but not `stop`,
`start` or `restart`.

You can delcare a site policy - for example to give your admins access to all actions on all
agents.  And you can define per module policy.  All via Hiera

The default applied to all modules can be set site wide:

```yaml
mcollective::policy_default: allow
```

You can then specify a site wide policy, here I let myself access everything on all agents:

```yaml
mcollective::site_policies:
- action: "allow"
  callers: "cert=rip.mcollective"
  actions: "*"
  facts: "*"
  classes: "*"
```

Site wide policies are applied *after* agent specific ones, be aware of that when constructing
site rules.

Specific policies can be specified per agent - but note they override the agent specific default
policies so if you specify any you have to specify all:

```yaml
mcollective_agent_puppet::policy_default: allow
mcollective_agent_puppet::policies:
- action: "allow"
  callers: "cert=developer.mcollective"
  actions: "*"
  facts: "environment=development"
  classes: "*"
```

In this way plugins can check their default policy into their repo using the `.plugin.yaml` file,
more on that below.

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
