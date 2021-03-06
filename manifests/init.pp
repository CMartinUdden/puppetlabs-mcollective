# Class - mcollective
class mcollective (
  # which subcomponents to install here
  $server = true,
  $client = false,

  # installing packages
  $manage_packages   = true,
  $version           = 'present',
  $ruby_stomp_ensure = 'installed',

  # core configuration
  $confdir          = '/etc/mcollective',
  $main_collective  = 'mcollective',
  $collectives      = 'mcollective',
  $connector        = 'activemq',
  $securityprovider = 'psk',
  $psk              = 'changemeplease',
  $userssl          = true,
  $factsource       = 'yaml',
  $yaml_fact_path   = undef,
  $excluded_facts   = [],
  $classesfile      = '/var/lib/puppet/state/classes.txt',
  $rpcauthprovider  = 'action_policy',
  $rpcauditprovider = 'logfile',
  $registration     = undef,
  $core_libdir      = $mcollective::defaults::core_libdir,
  $site_libdir      = $mcollective::defaults::site_libdir,

  # networking
  $middleware_hosts          = [],
  $middleware_user           = 'mcollective',
  $middleware_password       = 'marionette',
  $middleware_port           = '61613',
  $middleware_ssl_port       = '61614',
  $middleware_ssl            = false,
  $middleware_ssl_fallback   = false,
  $middleware_admin_user     = 'admin',
  $middleware_admin_password = 'secret',

  # middleware connector tweaking
  $rabbitmq_vhost = '/mcollective',

  $pluginconf          = {},
  # server-specific
  $server_config_file  = undef, # default dependent on $confdir
  $server_logfile      = '/var/log/mcollective.log',
  $server_keeplogs     = '5',
  $server_max_log_size = '2097152',
  $server_loglevel     = 'info',
  $server_daemonize    = 1,
  $service_name        = 'mcollective',
  $common_package      = 'mcollective',
  $ruby_stomp_package  = 'ruby-stomp',

  # client-specific
  $client_config_file  = undef, # default dependent on $confdir
  $client_logger_type  = 'console',
  $client_loglevel     = 'warn',
  $client_keeplogs     = '5',
  $client_max_log_size = '2097152',
  $client_package      = 'mcollective-client',

  # ssl certs
  $ssl_ca_cert          = undef,
  $ssl_server_public    = undef,
  $ssl_server_private   = undef,
  $ssl_client_certs     = 'puppet:///modules/mcollective/empty',
  $ssl_client_keys      = 'puppet:///modules/mcollective/empty',
  $ssl_client_certs_dir = undef, # default dependent on $confdir

  # timeouts
  $connection_timeout   = '1',
  $publish_timeout      = '1',
  $discovery_timeout    = '1',
) inherits mcollective::defaults {

  # Because the correct default value for several parameters is based on another
  # configurable parameter, it cannot be set in the parameter defaults above and
  # _real variables must be set here.
  $yaml_fact_path_real = pick($yaml_fact_path, "${confdir}/facts.yaml")
  $server_config_file_real = pick($server_config_file, "${confdir}/server.cfg")
  $client_config_file_real = pick($client_config_file, "${confdir}/client.cfg")
  $ssl_client_certs_dir_real = pick($ssl_client_certs_dir, "${confdir}/clients")
  $ssl_client_keys_dir_real = pick($ssl_client_certs_dir, "${confdir}/private")

  if $client or $server {
    contain mcollective::common
  }
  if $client {
    contain mcollective::client
  }
  if $server {
    contain mcollective::server
  }
}
