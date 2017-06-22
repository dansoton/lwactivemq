class lwactivemq::install (

  $bonecpsource = $lwactivemq::params::bonecpsource,
  $bonecpdest = $lwactivemq::params::bonecpdest,
  $source = $lwactivemq::params::source,
  $finaldest = $lwactivemq::params::finaldest,
  $servicename = $lwactivemq::params::servicename,
  $mysqljdbcsource = $lwactivemq::params::mysqljdbcsource,
  $mysqljdbcdest = $lwactivemq::params::mysqljdbcdest,
  $activemquser = $lwactivemq::params::activemquser,
  $max_heap = $lwactivemq::params::max_heap,
  $min_heap = $lwactivemq::params::min_heap,
  $mq_db_username = $lwactivemq::params::mq_db_username,
  $mq_db_password = $lwactivemq::params::mq_db_password,
  $mq_cluster_type = $lwactivemq::params::mq_cluster_type,
  $mq_cluster_conn = $lwactivemq::params::mq_cluster_conn,
  $mq_db_url_string = $lwactivemq::params::mq_db_url_string,
  $mq_security = $lwactivemq::params::mq_security,
  $usejmx = $lwactivemq::params::usejmx,
  $jmxport = $lwactivemq::params::jmxport,
  $jmxuser = $lwactivemq::params::jmxuser,
  $jmxpassword = $lwactivemq::params::jmxpassword,
  $consoleusername = $lwactivemq::params::consoleusername,
  $consolepassword = $lwactivemq::params::consolepassword,
  $consoleroles = $lwactivemq::params::consoleroles,
  $createqueuestopics = $lwactivemq::params::createqueuestopics,
  $amqqueues = $lwactivemq::params::amqqueues,
  $amqtopics = $lwactivemq::params::amqtopics,
  ) inherits lwactivemq::params {

    Exec { user => 'activemq'}

    $amq_array = split($source, '/')
    $amq_file = $amq_array[-1]

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
      path    =>  '/bin',
      cwd     =>  $destination,
      creates => "${destination}/apache-activemq-${amq_version}"
    } ->

    exec { "cp -R ${destination}/apache-activemq-${amq_version}/. ${finaldest}":
      path    =>  '/bin',
      cwd     => '/usr',
      creates => "${finaldest}/README.txt"
    } ->

    file {'/etc/init/activemq.conf':
      ensure  => 'file',
      content => template('lwactivemq/activemq.conf.erb'),
      owner   => $activemquser,
    } ->

    file { '/etc/default/activemq':
      ensure => "file",
      owner => $activemquser,
    } ->

    file_line { 'activemqopts':
      path  => '/etc/default/activemq',
      line  => "ACTIVEMQ_OPTS=\"-Xms${min_heap} -Xmx${max_heap} -Dorg.apache.activemq.UseDedicatedTaskRunner=true -Djava.util.logging.config.file=logging.properties -Djava.security.auth.login.config=/usr/ActiveMQ/conf/login.config\"",
      match => '^ACTIVEMQ_OPTS.*',
      notify => Service[$servicename],
    } ->

    file {'/usr/ActiveMQ/conf/activemq.xml':
      ensure  => 'file',
      content => template('lwactivemq/activemq.xml.erb'),
      owner   => $activemquser,
      notify  => Service[$servicename],
  }

  if $mq_cluster_conn == 'mysql' {

      exec{ 'getjdbcdriver':
        command => "/usr/bin/wget -q ${mysqljdbcsource} -O ${mysqljdbcdest}/${mysqljdbc_file}",
      }

      exec{ 'getbonecpdriver':
        command => "/usr/bin/wget -q ${bonecpsource} -O ${bonecpdest}/${bonecp_file}",
      }

      file { "${mysqljdbcdest}/${mysqljdbc_file}":
        ensure => file,
        owner  => $activemquser,
        notify => Service[$servicename],
      }

      file { "${bonecpdest}/${bonecp_file}":
        ensure => file,
        owner  => $activemquser,
        notify => Service[$servicename],
      }
  }

    service { $servicename:
      ensure     => 'running',
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      provider => 'upstart',
    }

  if $mq_security {
    file_line { 'setconsoleuser':
      path  => '/usr/ActiveMQ/conf/jetty-realm.properties',
      line  => "${consoleusername}: ${consolepassword}, ${consoleroles}",
      notify => Service[$servicename],
    }
  }

  if $usejmx {
    
    file_line { 'runactivemqas':
      path  => '/etc/default/activemq',
      line  => "ACTIVEMQ_USER=\"activemq\"",
      match => '^ACTIVEMQ_USER.*',
      notify => Service[$servicename],
    }

    file_line { 'jmxsetup':
      path  => '/etc/default/activemq',
      line  => "SUNJMX=\"-Dcom.sun.management.jmxremote.port=${jmxport} -Dcom.sun.management.jmxremote.rmi.port=${jmxport} -Djava.rmi.server.hostname=$ipaddress -Dcom.sun.management.jmxremote.password.file=/usr/ActiveMQ/conf/jmx.password -Dcom.sun.management.jmxremote.access.file=/usr/ActiveMQ/conf/jmx.access -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote\"",
      match => '^SUNJMX.*',
      notify => Service[$servicename],
    }

    file_line { 'jmxusername':
      path => "${finaldest}/conf/jmx.access",
      line => "${jmxuser} readwrite",
      notify => Service[$servicename],
    }

    file_line { 'jmxpassword':
      path => "${finaldest}/conf/jmx.password",
      line => "${jmxuser} ${jmxpassword}",
      notify => Service[$servicename],
    }

    file { "${finaldest}/conf/jmx.password":
      ensure => file,
      mode   => '0600',
      notify => Service[$servicename],
    }
  }

  }
