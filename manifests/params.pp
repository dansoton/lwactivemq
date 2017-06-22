# Private
class lwactivemq::params {
  $activemquser = 'activemq'
  $activemqrundirectory = '/usr/ActiveMQ'
  $activemqtarholder = '/opt/activemqinstall'
  $source = 'http://archive.apache.org/dist/activemq/5.10.0/apache-activemq-5.10.0-bin.tar.gz'
  $destination = '/opt/activemqinstall'
  $finaldest = '/usr/ActiveMQ'
  $servicename = 'activemq'
  $max_heap = '3072m'
  $min_heap = '3072m'
  $mq_cluster_type = 'activepassive' #activepassive or nocluster
  $mq_cluster_conn = 'mysql' # mysql and there will be others as this matures
  $mq_db_username = 'activemq' # this is a space holder.  Change to your db username.
  $mq_db_password = 'activemq' # this is a space holder.  Change to your db pw.
  $mysqljdbcsource = 'http://connector.jar' # this is a jar file.  untar from location http://dev.mysql.com/downloads/connector/j/ and link to jar destination
  $mysqljdbcdest = '/usr/ActiveMQ/lib/optional'
  $bonecpdest = '/usr/ActiveMQ/lib/optional'
  $mq_security = false
  $usejmx = false
  $jmxport = '11099'
  $jmxuser = 'jmxuser' # this is a space holder.  Change to your jmx username.
  $jmxpassword = 'jmxpassword' # this is a space holder.  Change to your jmx password.
  $consoleusername = '' # this is a default username.  Change to your console username.
  $consolepassword = '' # this is a default username.  Change to your console password.
  $consoleroles = '' # this is a default role(s).  Change to your console role.
  $createqueuestopics = false # this is a default value if you want to create queues or topics on broker startup
  $amqqueues = ''
  $amqtopics = ''
}
