class lwactivemq::install (

  $source = $lwactivemq::params::source,
  $finaldest = $lwactivemq::params::finaldest,
  $servicename = $lwactivemq::params::servicename,
  $version = $lwactivemq::params::version,
  $mysqljdbcsource = $lwactivemq::params::mysqljdbcsource,
  $mysqljdbcdest = $lwactivemq::params::mysqljdbcdest,
  $activemquser = $lwactivemq::params::activemquser,
  $mq_db_username = $lwactivemq::params::mq_db_username,
  $mq_db_password = $lwactivemq::params::mq_db_password,
  $mq_cluster_type = $lwactivemq::params::mq_cluster_type,
  $mq_cluster_conn = $lwactivemq::params::mq_cluster_conn,
  $dbname = $lwactivemq::params::dbname,
  $fullservername = $lwactivemq::params::fullservername,

  ) inherits lwactivemq::params {
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

    file {"/usr/ActiveMQ/conf/activemq.xml":
      ensure  => 'file',
      content => template('lwactivemq/activemq.xml.erb'),
      owner   => $activemquser,
      notify => Service[$servicename],
  }

  case $mq_cluster_conn {
    'mysql': {

      exec{ "getjdbcdriver":
        command => "/usr/bin/wget -q ${mysqljdbcsource} -O ${mysqljdbcdest}/mysql-connector-java-5.1.25.jar",
      }

      file { '/usr/ActiveMQ/lib/optional/mysql-connector-java-5.1.25.jar':
        ensure  => file,
        owner   => $activemquser,
        notify => Service[$servicename],
      }
    }
    }


  }
