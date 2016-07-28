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

  * [Choria Orchestrator](https://github.com/ripienaar/mcollective-choria) Puppet Security, NATS connector, PuppetDB discovery and Application Orchastrator
  * [Puppet Agent](https://github.com/puppetlabs/mcollective-puppet-agent), [Package Agent](https://github.com/puppetlabs/mcollective-package-agent), [Service Agent](https://github.com/puppetlabs/mcollective-service-agent), [File Manager Agent](https://github.com/puppetlabs/mcollective-filemgr-agent)
  * [Action Policy Authorization](https://github.com/puppetlabs/mcollective-actionpolicy-auth) with default secure settings
  * Audit logs in `/var/log/puppetlabs/mcollective-audit.log` and `C:/ProgramData/PuppetLabs/mcollective/var/log/mcollective-audit.log`
  * Facts using a YAML file refreshed using Cron or Windows Scheduler
  * Configures the main `server.cfg` and `client.cfg` and service
  * Provides an MCollective plugin packager that produce AIO specific modules of mco plugins
  * Custom `mcollective` fact exposing key client and server configuration and version

Installation
------------

Follow the guide at the [Choria Wiki](https://github.com/ripienaar/mcollective-choria/wiki)

Facts
-----

The only supported fact source is YAML and it will refresh on every Puppet run and by default
from Cron and Windows Scheduler.

Set `mcollective::facts_refresh_interval` to `0` to disable the scheduled updates.  At present
the output path cannot be changed and by default it will configure the daemon to the same path.

You can adjust the path to include additional YAML files if you wish by updating it to consider
multiple YAML files by specifying a `File::PATH_SEPARATOR` seperated list of paths.
