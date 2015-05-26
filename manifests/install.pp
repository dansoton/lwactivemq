class lwactivemq::install (

  $source = $lwactivemq::params::source,
  $finaldest = $lwactivemq::params::finaldest,
  $servicename = $lwactivemq::params::servicename,
  $version = $lwactivemq::params::version,

  ) inherits activemq::params {
    exec { "/usr/bin/wget -N ${source}":
      cwd =>  $destination,
    } ->

    exec { "tar -xvzf $destination/apache-activemq-${version}-bin.tar.gz":
      path =>  "/bin",
      cwd =>  $destination,
      creates => "${destination}/apache-activemq-${version}"
    } ->

    exec { "cp -R ${destination}/apache-activemq-${version} ${finaldest}":
      path =>  "/bin",
      cwd => "/usr",
      creates => "${finaldest}/README.txt"
    } ->

    exec {"ln -sf /usr/ActiveMQ/bin/activemq /etc/init.d/":
      path  => "/bin",
      creates => "/etc/init.d/activemq"
    } ->

    exec {"/etc/init.d/activemq setup /etc/default/activemq":
      path  => "/bin",
      creates => "/etc/default/activemq"
    } ->

    service { $servicename:
      ensure => 'running',
      enable  => true,
      hasstatus => true,
      hasrestart  => true,
    }

  }
