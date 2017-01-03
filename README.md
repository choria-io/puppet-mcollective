Manage an AIO Installation of The Marionette Collective
=======================================================

This module manages a Puppet AIO based MCollective.

It makes default decisions that are compatible with AIO and tries to get as
close to working out of the box with no complex config or decision making needed
on the side of the user.

The module can be used standalone but it's designed to work with Choria - a companion
suite of plugins that makes a AIO based MCollective easy to install and use.

Follow the guide at the [Choria Website](http://choria.io) for installation details

Facts
-----

The only supported fact source is YAML and it will refresh on every Puppet run and by default
from Cron and Windows Scheduler.

Set `mcollective::facts_refresh_interval` to `0` to disable the scheduled updates.  At present
the output path cannot be changed and by default it will configure the daemon to the same path.

You can adjust the path to include additional YAML files if you wish by updating it to consider
multiple YAML files by specifying a `File::PATH_SEPARATOR` seperated list of paths.
