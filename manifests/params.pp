# Private
class activemq::params {
  $activemquser = 'activemq'
  $activemqrundirectory = '/usr/ActiveMQ'
  $activemqtarholder = '/opt/activemqinstall'
  $source = 'http://archive.apache.org/dist/activemq/5.10.0/apache-activemq-5.10.0-bin.tar.gz'
  $destination = '/opt/activemqinstall'
  $finaldest = '/usr/ActiveMQ'
  $servicename = 'activemq'
  $version = '5.10.0'
  $mq_cluster_type = 'activepassive' #activepassive or nocluster
  $mq_cluster_conn = 'mysql' # mysql and there will be others as this matures
}
