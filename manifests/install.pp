class lwactivemq::install (

  $bonecpsource = $lwactivemq::params::bonecpsource,
  $bonecpdest = $lwactivemq::params::bonecpdest,
  $source = $lwactivemq::params::source,
  $finaldest = $lwactivemq::params::finaldest,
  $servicename = $lwactivemq::params::servicename,
  $mysqljdbcsource = $lwactivemq::params::mysqljdbcsource,
  $mysqljdbcdest = $lwactivemq::params::mysqljdbcdest,
  $activemquser = $lwactivemq::params::activemquser,
  $mq_db_username = $lwactivemq::params::mq_db_username,
  $mq_db_password = $lwactivemq::params::mq_db_password,
  $mq_cluster_type = $lwactivemq::params::mq_cluster_type,
  $mq_cluster_conn = $lwactivemq::params::mq_cluster_conn,
  $mq_db_url_string = $lwactivemq::params::mq_db_url_string,
  $mq_security = $lwactivemq::params::mq_security,

  ) inherits lwactivemq::params {

    $amq_array = split($source, '/')
    $amq_file = $amq_array[-1]

'http://archive.apache.org/dist/activemq/5.10.0/apache-activemq-5.10.0-bin.tar.gz'

    $amqversion_array = split($source, '-')
    $amq_version = $amqversion_array[-2]

    $mysqljdbc_array = split($mysqljdbcsource, '/')
    $mysqljdbc_file = $mysqljdbc_array[-1]

    $bonecp_array = split($bonecpsource, '/')
    $bonecp_file = $bonecp_array[-1]

    exec { "/usr/bin/wget -N ${source}":
      cwd =>  $destination,
    } ->

    exec { "tar -xvzf $destination/$amq_file":
      path =>  "/bin",
      cwd =>  $destination,
      creates => "${destination}/apache-activemq-${amq_version}"
    } ->

    exec { "cp -R ${destination}/apache-activemq-${amq_version}/. ${finaldest}":
      path =>  "/bin",
      cwd => "/usr",
      creates => "${finaldest}/README.txt"
    } ->

    exec {"ln -sf /usr/ActiveMQ/bin/activemq /etc/init.d/":
      path  => "/bin",
      creates => "/etc/init.d/activemq",
      notify => Service[$servicename]
    } ->

    exec {"/etc/init.d/activemq setup /etc/default/activemq":
      path  => "/bin",
      creates => "/etc/default/activemq",
      notify => Service[$servicename]
    } ->


    file {"/usr/ActiveMQ/conf/activemq.xml":
      ensure  => 'file',
      content => template('lwactivemq/activemq.xml.erb'),
      owner   => $activemquser,
      notify => Service[$servicename],
  } ->

  case $mq_cluster_conn {
    'mysql': {

      exec{ "getjdbcdriver":
        command => "/usr/bin/wget -q ${mysqljdbcsource} -O ${mysqljdbcdest}/${mysqljdbc_file}",
      }

      exec{ "getbonecpdriver":
        command => "/usr/bin/wget -q ${bonecpsource} -O ${bonecpdest}/${bonecp_file}",
      }

      file { "${mysqljdbcdest}/${mysqljdbc_file}":
        ensure  => file,
        owner   => $activemquser,
        notify => Service[$servicename],
      }

      file { "${bonecpdest}/${bonecp_file}":
        ensure  => file,
        owner   => $activemquser,
        notify => Service[$servicename],
      }
    }
  } ->

    service { $servicename:
      ensure => 'running',
      enable  => true,
      hasstatus => true,
      hasrestart  => true,
    }


  }
