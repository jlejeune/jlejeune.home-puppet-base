#
# Some configuration for nginx
#

class base::nginx {
  # Packages
  package { 'nginx':
    ensure  => latest
  }

  # Main files
  file { '/var/www/html/':
    ensure    => directory,
    owner     => 'www-data',
    group     => 'www-data',
    recurse   => true,
  }

  file { "/var/www/html/.well-known":
    ensure    => directory,
    owner     => 'www-data',
    group     => 'www-data',
    require   => File['/var/www/html/'],
  }

  file { '/var/www/html/index.html':
    ensure    => file,
    content   => template("${module_name}/nginx-default-index"),
    owner     => 'www-data',
    group     => 'www-data',
    require   => File['/var/www/html/'],
  }

  file { '/etc/nginx/drop.conf':
    ensure    => file,
    content   => template("${module_name}/nginx-drop-conf"),
    require   => Package['nginx'],
    notify    => Service['nginx'],
  }

  file { '/etc/nginx/ssl.conf':
    ensure    => file,
    content   => template("${module_name}/nginx-ssl-conf"),
    require   => Package['nginx'],
    notify    => Service['nginx'],
  }

  file { '/etc/nginx/proxy_params':
    ensure    => file,
    content   => template("${module_name}/nginx-proxy-conf"),
    require   => Package['nginx'],
    notify    => Service['nginx'],
  }

  file { '/etc/nginx/sites-available/default':
    ensure    => file,
    content   => template("${module_name}/nginx-default-vhost"),
    require   => Package['nginx'],
    notify    => Service['nginx'],
  }
  ->
  file { '/etc/nginx/sites-enabled/default':
    ensure    => link,
    target    => '/etc/nginx/sites-available/default',
    notify    => Service['nginx'],
  }

  file { '/etc/nginx/sites-available/nas.jlejeune.eu':
    ensure    => file,
    content   => template("${module_name}/nginx-nas-vhost"),
    require   => Package['nginx'],
    notify    => Service['nginx'],
  }
  ->
  file { '/etc/nginx/sites-enabled/nas.jlejeune.eu':
    ensure    => link,
    target    => '/etc/nginx/sites-available/nas.jlejeune.eu',
    notify    => Service['nginx'],
  }

  file { '/etc/nginx/sites-available/videos.jlejeune.eu':
    ensure    => file,
    content   => template("${module_name}/nginx-videos-vhost"),
    require   => Package['nginx'],
    notify    => Service['nginx'],
  }
  ->
  file { '/etc/nginx/sites-enabled/videos.jlejeune.eu':
    ensure    => link,
    target    => '/etc/nginx/sites-available/videos.jlejeune.eu',
    notify    => Service['nginx'],
  }

  file { '/etc/nginx/sites-available/photos.jlejeune.eu':
    ensure    => file,
    content   => template("${module_name}/nginx-photos-vhost"),
    require   => Package['nginx'],
    notify    => Service['nginx'],
  }
  ->
  file { '/etc/nginx/sites-enabled/photos.jlejeune.eu':
    ensure    => link,
    target    => '/etc/nginx/sites-available/photos.jlejeune.eu',
    notify    => Service['nginx'],
  }

  file { '/etc/nginx/sites-available/webdav.jlejeune.eu':
    ensure    => file,
    content   => template("${module_name}/nginx-webdav-vhost"),
    require   => Package['nginx'],
    notify    => Service['nginx'],
  }
  ->
  file { '/etc/nginx/sites-enabled/webdav.jlejeune.eu':
    ensure    => link,
    target    => '/etc/nginx/sites-available/webdav.jlejeune.eu',
    notify    => Service['nginx'],
  }

  # letsencrypt
  class { letsencrypt:
      email  => 'julien@mailops.fr',
  }

  letsencrypt::certonly { 'jlejeune':
    domains              => ['www.jlejeune.eu', 'nas.jlejeune.eu', 'videos.jlejeune.eu', 'photos.jlejeune.eu', 'webdav.jlejeune.eu'],
    plugin               => 'webroot',
    webroot_paths        => ['/var/www/html'],
    manage_cron          => true,
    cron_success_command => '/bin/systemctl reload nginx.service',
  }

  service { 'nginx':
    ensure    => running,
  }
}
