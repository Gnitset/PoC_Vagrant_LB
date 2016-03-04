package { 'nginx-full':
  ensure => installed,
  provider => 'apt'
}

file {
  '/etc/nginx/sites-enabled/lb.conf':
    source => '/vagrant/files/nginx-lb.conf',
    require => Package['nginx-full'];
  '/etc/nginx/sites-enabled/default':
    ensure  => 'absent',
    purge   => true,
    require => Package['nginx-full'];
  '/etc/nginx/ssl':
    ensure => 'directory';
  '/etc/nginx/conf.d/lb_upstream.conf':
    content => 'upstream lb_upstream {',
    require => Package['nginx-full'];
}

exec {
  'generate-certs':
    command => '/usr/bin/openssl req -x509 -subj /C=SE/L=Stockholm/O=VLB/CN=localhost -new -nodes -newkey rsa:2048 -keyout /etc/nginx/ssl/lb.key -out /etc/nginx/ssl/lb.crt > /dev/null',
    require => File['/etc/nginx/ssl'];
}

include stdlib
$a_nodes = split($nodes, ",")
$a_nodes.each | $node | {
  file_line { "$node":
    path => '/etc/nginx/conf.d/lb_upstream.conf',
    line => "  server 10.99.80.$node;",
    require => File['/etc/nginx/conf.d/lb_upstream.conf'];
  }
}
file_line { 'upstream_end':
  path => '/etc/nginx/conf.d/lb_upstream.conf',
  line => '}',
  require => map($a_nodes) |$node| { File_Line[$node] },
  notify => Service['nginx'];
}

service { 'nginx':
  ensure  => 'running',
  enable  => true,
  require => Package['nginx-full'],
}

