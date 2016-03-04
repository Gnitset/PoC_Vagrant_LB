package { 'nginx-light':
  ensure => installed,
  provider => 'apt'
}

file {
  '/var/www/html/index.html':
    content => $node,
    require => Package['nginx-light'];
}
