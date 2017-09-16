#
# TMUX config
#

class base::tmux {
  File {
    owner   => 'root',
    group   => 'root',
  }

  file { '/etc/tmux/':
    ensure  => directory,
  }

  file { '/etc/tmux/tmux.conf':
    ensure  => present,
    source  => "puppet:///modules/${module_name}/tmux/tmux.conf",
  }

  file { '/etc/tmux/default-binding-keys.conf':
    ensure  => present,
    source  => "puppet:///modules/${module_name}/tmux/default-binding-keys.conf",
  }

  file { '/usr/local/bin/tmux.sh':
    ensure  => present,
    source  => "puppet:///modules/${module_name}/tmux/tmux.sh",
  }

  # Set some aliases
  bash::alias { 'tmux':
    content => '/usr/local/bin/tmux.sh ',
  }
}
