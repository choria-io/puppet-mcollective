|Date      |Issue|Description                                                                                              |
|----------|-----|---------------------------------------------------------------------------------------------------------|
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
