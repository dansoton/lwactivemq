# Private
class lwactivemq::params {
  $activemquser = 'activemq'
  $activemqrundirectory = '/usr/ActiveMQ'
  $activemqtarholder = '/opt/activemqinstall'
  $source = 'http://archive.apache.org/dist/activemq/5.10.0/apache-activemq-5.10.0-bin.tar.gz'
  $destination = '/opt/activemqinstall'
  $finaldest = '/usr/ActiveMQ'
  $servicename = 'activemq'
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
}
