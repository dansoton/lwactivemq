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
