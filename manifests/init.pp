# == Class: lwactivemq
#
# Full description of class activemq here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { activemq:
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name john.cook@lifeway.com
#
# === Copyright
#
# Copyright 2015 John Cook, unless otherwise noted.
#
class lwactivemq (
  $activemquser = $lwactivemq::params::activemquser,
  $activemqrundirectory = $lwactivemq::params::activemqrundirectory,
  $activemqtarholder = $lwactivemq::params::activemqtarholder,
  ) inherits lwactivemq::params {

  user { $activemquser:
    ensure    => present,
    shell     => '/bin/bash',
    home      => "/home/${user}",
  }

  file { $activemqrundirectory:
    ensure    => "directory",
    owner     => $activemquser,
    recurse   => true,
  }

  file{ $activemqtarholder:
    ensure    => "directory",
    owner     => $activemquser,
    recurse   => true,
  }

}
