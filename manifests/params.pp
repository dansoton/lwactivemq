# Private
class lwactivemq::params {
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
  $mq_db_username = 'activemq'
  $mq_db_password = 'activemq'
  $fullservername = 'defaultservername'
  $dbname = 'default'
  $mysqljdbcsource = 'https://s3.amazonaws.com/lifeway-binaries/temp/tomcatjars/mysql-connector-java-5.1.25.jar'
  $mysqljdbcdest = '/usr/ActiveMQ/lib/optional'
}
