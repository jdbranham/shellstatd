#shellstatd 
shellstatd gathers OS-level performance statistics and sends
them to a running instance of Graphite.

It is a collection of bash shell scripts that gather the output
from existing system monitoring tools to aggregate and forward the data on to Graphite where it can be
visualized.

There are other, more "production-ready" tools (like collectd, with
the graphite plugin) that do this. But there are some cases where those tools are unavailable. 

  * This is a simple, fast, minimal configuration tool
  
  * Does not require Netcat [nc]

  * This works on system with no internet access, or older production systems that would require compiling dependencies for tools like collectd.


shellstatd is tested and works on CentOS (Fedora) and Ubuntu
(Debian).  With small modifications it could be made to work
on OS X, Solaris, etc.  


Prerequisites:
    * The systat package must be installed if you wish to use the 
      'sar' and 'iostat' monitoring tools.  (The vmstat
      tools should work out of the box for all distros)  CentOS seems
      to have systat installed by default, but Debian/Ubuntu users
      need to install it via apt-get.


To install shellstatd, run installer.sh.  Usage:

    [sudo] ./install.sh <install dir> <graphite host> <monitor interval> [ graphite port (default is 2003) ]


To modify shellstatd settings (such as which metrics you wish to
monitor), edit /etc/shellstatd.conf.


Command Line Usage:

    shellstatd [start | stop | restart] [OPTION]
    Options:
    -c    Configuration File Location
    -l    Log File Location



shellstatd can be controlled by a startup script in '/etc/init.d' if you used sudo to install.  Usage:

    /etc/init.d/shellstatd  start | stop | restart


# Modules
> jolokia
- Aggregates and formats json output from a jolokia server 
- Add Jolokia request URLs to "conf/jolokia.conf", one on each line, for the Jolokia monitor to aggregate metrics and forward them to Graphite
- An optional python script can be enabled in "conf/shellstatd.conf" to enable 'pickling' the data.


 
> df
- Aggregates all the disk mount points and the used/available space

> iostat
- Formats and send iostat data
 
> mpstat
- Formats and sends mpstat data
 
> sar_load
- Formats and sends load avgs for sar
 
> sar_network
- Formats and sends network interface data from sar
 
> vmstat
- Formats and sends data from vmstat
 



Thanks to Travis Bear from which this project was based on -
https://bitbucket.org/travis_bear/quickstatd

