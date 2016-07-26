Manage an AIO Installation of The Marionette Collective
=======================================================

This module manages an already installed Puppet AIO based MCollective.

It makes default decisions that are compatible with AIO and tries to get as
close to working out of the box with no complex config or decision making needed
on the side of the user.

Towards this it makes many of decisions related to security plugin, middleware,
facts etc and finally installs a number of plugins out of the box.

The goal is that this Just Works while being secure by default.  It sets up strong
CA verified TLS connections to your middleware and sets up a similar CA verified
security plugin for MCollective.

It configures the full AAA (Authentication, Authorization and Auditing) that MCollective
supports and it all works out of the box.

Users do not need per-user configuration files and it integrates well and naturally
into the Puppet eco system.

Components Installed / Configured
---------------------------------

  * [Choria Orchestrator](https://github.com/ripienaar/mcollective-choria) Puppet Security, NATS connector, PuppetDB security and Application Orchastrator
  * [Puppet Agent](https://github.com/puppetlabs/mcollective-puppet-agent)
  * [Package Agent](https://github.com/puppetlabs/mcollective-package-agent)
  * [Service Agent](https://github.com/puppetlabs/mcollective-service-agent)
  * [File Manager Agent](https://github.com/puppetlabs/mcollective-filemgr-agent)
  * [Action Policy Authorization](https://github.com/puppetlabs/mcollective-actionpolicy-auth) with default secure settings
  * Audit logs in `/var/log/puppetlabs/mcollective-audit.log` and `C:/ProgramData/PuppetLabs/mcollective/var/log/mcollective-audit.log`
  * Facts using a YAML file refreshed using Cron or Windows Scheduler
  * Configures the main `server.cfg` and `client.cfg` and service
  * Provides an MCollective plugin packager that produce AIO specific modules of mco plugins
  * Custom `mcollective` fact exposing key client and server configuration and version

Installation
------------

You must have an AIO Puppet setup to communicate with a Puppet Master and it should already
have certs, which by convention should match `fqdn`.  The new security plugins require these
certs.

You need a middleware connector, this module sets up a NATS.io based connector but does not yet configure
the middleware for you.  See the notes at the [Choria Wiki](https://github.com/ripienaar/mcollective-choria/wiki).
This module or a companion one will soon configure this for you.

On nodes due to the `eventmachine` dependency of the NATS Gem you must have compilers installed,
on my RedHat machine that means the packages `gcc`, `gcc-c++` and `make`.  If you do not already
manage those somehow you can ask this code to install it for you by making Hiera data:

```yaml
mcollective_connector_nats::package_dependencies:
  "gcc": present
  "gcc-c++": present
  "make": present
```

This way you can customise it for your various operating systems and so forth via Hiera tiers.

Alternatively you can package the `eventmachine` dependency up using your in house required methods
and disable the dependency management by the connector module, this way you do not need to install
compilers everywhere:

```yaml
mcollective_connector_nats::manage_gem_dependencies: false
```

Once you have a middleware install the `ripienaar-mcollective` module in your environment, it will
bring in all its dependencies.

On a managed node include `mcollective`.

On a managed node that should also have client tools set `mcollective::client` to `true`.

If you have a node that should only be able to use the client tools and not also run the daemon
you can set `mcollective::server` to `false`.

Clients who wish to use the `mco` cli need a Puppet CA provided certificate; you obtain these
with:

```
$ mco choria request_cert
```

Using the `mco` utilities as `root` is not encouraged and so not supported.

Once the certificate is signed and downloaded you can use the utilities.  If fetching the cert
times out, you can just run this command again once the certs are signed.

Configuring Server and Client
-----------------------------

In general you should not need to change settings, if your PuppetDB, Puppet Server or NATS
is not on the host `puppet` it's recommended you use SRV records to configure where these
parts live, otherwise refer to the [Choria Wiki](https://github.com/ripienaar/mcollective-choria/wiki)
for a guide on configuring security, connector and discovery.

Server and Client settings are managed using Hiera data and these keys are set up for deep
hash merging using look up strategies.  It's free form and generally there aren't specific
options on the module to set things, just feed in data.  Sub Collectives and Main Collective
is a notable deviation from this rule.

Some settings like the connector and security provider tend to be common to the Client and
Server, these are configured using Hiera:

```yaml
mcollective::common_config:
  securityprovider: puppet
```

This will result in both the main `server.cfg` and `client.cfg` having these settings.

Likewise client or server specific settings can be set with `mcollective::client_config`
and `mcollective::server_config`.

To enable a specific node to be an MCollective client you have to set `mcollective::client`
to `true` via hiera

If you have PuppetDB installed and the SSL port listening and reachable you can test the
PuppetDB based discovery by passing `--dm choria`, if you like that you can enable it
by default:

```yaml
mcollective::client_config:
  default_discovery_method: "choria"
```

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

You can then specify a site wide policy, here I let myself access everything on all agents, these
are array merged by hiera:

```yaml
mcollective::site_policies:
- action: "allow"
  callers: "choria=rip.mcollective"
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
  callers: "choria=developer.mcollective"
  actions: "*"
  facts: "environment=development"
  classes: "*"
```

In this way plugins can check their default policy into their repo using the `.plugin.yaml` file,
more on that below.

There is one special plugin called `rpcutil` that ships with MCollective, policies for this one
by default allow only its `ping` action across all users, you can adjust this with
`mcollective::rpcutil_policies`.  This should be a sane default that does not leak environment
details more than `mco ping` already allows.

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
