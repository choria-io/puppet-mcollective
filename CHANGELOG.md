|Date      |Issue|Description                                                                                              |
|----------|-----|---------------------------------------------------------------------------------------------------------|
|2018/07/20|     |Release 0.7.0                                                                                            |
|2018/07/11|185  |Support Ubuntu 18.04                                                                                     |
|2018/06/17|183  |Improve Archlinux support                                                                                |
|2018/05/21|     |Release 0.6.0                                                                                            |
|2018/05/04|178  |Update location of JSON schema for agent DDLs                                                            |
|2018/04/26|176  |Create a `choria-shim.cfg` for the Choria Server Ruby compatability                                      |
|2018/04/25|174  |Unmanage the Ruby federation broker configuration directory                                              |
|2018/04/20|     |Release 0.5.0                                                                                            |
|2018/04/18|168  |Avoid refreshed of the facts exec when the cron is disabled                                              |
|2018/04/17|166  |Create JSON versions of Agent DDLs                                                                       |
|2018/03/26|     |Release 0.4.1                                                                                            |
|2018/03/25|163  |Work around for Puppet 5.5.0 breaking changes in facts loading                                           |
|2018/02/25|     |Release 0.4.0                                                                                            |
|2018/02/25|155  |Update `stdlib` dependency                                                                               |
|2018/02/02|152  |Ensure the `crontimes` function is not called when disabling the cronjob                                 |
|2018/01/04|151  |Remove dependency on the `mcollective_choria` module to avoid cycles in Librarian Puppet                 |
|2017/12/21|     |Release 0.3.0                                                                                            |
|2017/12/20|148  |Arch Linux support                                                                                       |
|2017/11/15|     |Release 0.2.1                                                                                            |
|2017/10/31|143  |Fix the ability to remove the facts cron from windows                                                    |
|2017/10/18|     |Release 0.2.0                                                                                            |
|2017/10/18|140  |Fix gathering mcollective facts from the fact cache builder                                              |
|2017/10/18|138  |Allow plugins to supply additional Puppet files to copy into modules                                     |
|2017/09/21|     |Release 0.1.0                                                                                            |
|2017/09/08|128-134|Support FreeBSD                                                                                        |
|2017/09/08|126  |Improve unixlike behaviour in plugin permissions                                                         |
|2017/08/19|     |Release 0.0.29                                                                                           |
|2017/08/18|123  |Ensure a valid `--vendor` is passed when building modules                                                |
|2017/08/02|     |Release 0.0.28                                                                                           |
|2017/06/22|111  |Purge unmanaged config items from the managed config files                                               |
|2017/06/19|113  |Randomize the start time of the facts cron job                                                           |
|2017/06/12|110  |Add support for OS X                                                                                     |
|2017/06/01|     |Release 0.0.27                                                                                           |
|2017/06/01|104  |Improve README template for generated modules                                                            |
|2017/06/01|103  |Remove deprecation warnings for generated modules on newer Puppet                                        |
|2017/05/28|102  |Remove deprecation warnings on newer Puppet                                                              |
|2017/04/27|98   |Support local gem mirrors via the `gem_source` property                                                  |
|2017/03/28|     |Release 0.0.26                                                                                           |
|2017/03/24|95   |Ensure the policy file exist before the ini settings are attempted                                       |
|2017/03/21|92   |Add utility to create config files                                                                       |
|2017/02/13|     |Release 0.0.25                                                                                           |
|2017/02/13|89   |Prevent multiple instances of the fact refresher from running                                            |
|2017/02/11|72   |When mcollective is not available in the RUBYLIB correctly handle the LoadError                          |
|2017/02/11|80   |Set the `project_page` in the generated modules when packaging a plugin                                  |
|2017/02/11|71   |Enable the `choria` auditing plugin by default                                                           |
|2017/02/11|     |Release 0.0.24 and move to `choria-io` project                                                           |
|2017/02/01|81   |Run the fact generator after the service is up                                                           |
|2017/01/29|78   |Convert `-` in module names to `_`                                                                       |
|2017/01/13|     |Release 0.0.23                                                                                           |
|2017/01/13|74   |Resolve issues with Windows paths in fact and libdir                                                     |
|2017/01/03|     |Release 0.0.22                                                                                           |
|2017/01/03|69   |Adjust dependencies so that librarian will install the module                                            |
|2016/11/10|     |Release 0.0.21                                                                                           |
|2016/11/09|67   |Improve handling of agents like the shell one with a invalid plugin layout                               |
|2016/08/27|     |Release 0.0.20                                                                                           |
|2016/08/27|63   |Deep merge mcollective::common_config                                                                    |
|2016/08/27|59   |Use a custom fact source - `generated-facts.yaml` - to improve bootstrapping                             |
|2016/08/27|60   |Configure the classes file according to AIO paths                                                        |
|2016/08/13|     |Release 0.0.19                                                                                           |
|2016/08/13|57   |Configure libdirs on windows and rework libdir calculations a bit towards specifically setting libdir    |
|2016/08/13|55   |Use the correct lib dirs for facter on windows                                                           |
|2016/08/13|54   |Correct typo on hiera data for windows                                                                   |
|2016/08/13|53   |Correct path to the ruby executable and fix quoting                                                      |
|2016/08/13|52   |Correct data types on mcollective::facts for windows support                                             |
|2016/08/11|     |Release 0.0.18                                                                                           |
|2016/08/11|47   |When refreshing facts with cron, do not run facts writer on every Puppet run                             |
|2016/08/09|43   |Correctly handle temp file renaming in cases where /tmp and /etc do not share a partition (Daniel Sung)  |
|2016/08/01|     |Release 0.0.17                                                                                           |
|2016/08/01|41   |Handle cases of both client=false and server=false gracefully in module installer                        |
|2016/08/01|41   |Uniquely tag agent ruby files to facilitate agent discovery                                              |
|2016/07/31|39   |Install action policies only on nodes with `$server` set                                                 |
|2016/07/28|37   |Fix file name for per plugin configs and allow purging old files                                         |
|2016/07/26|35   |Use ripienaar/mcollective-choria instead of specific modules                                             |
|2016/07/12|31   |Improve client sub collective handling                                                                   |
|2016/07/11|28   |Install the PuppetDB based discovery plugin                                                              |
|2016/07/11|25   |Add a `mcollective` fact with various useful information                                                 |
|2016/07/11|24   |Move main and audit logs into AIO standard paths                                                         |
|2016/07/09|21   |Allow the `rpcutil` agent policies to be managed, set sane defaults                                      |
|2016/07/09|19   |Manages native packages before Gems to allow for compilers to be installed before native gems            |
|2016/07/08|17   |Include the NATS.io connector                                                                            |
|2016/07/07|15   |Support writing factsyaml, include filemgr agent                                                         |
|2016/07/06|11   |Support collectives                                                                                      |
|2016/06/30|7    |Support auditlogs                                                                                        |
|2016/06/30|2    |Support Windows                                                                                          |
|2016/06/30|1    |Support actionpolicy                                                                                     |
|2016/06/29|4    |Remove hard coded paths and move them to Hiera                                                           |
