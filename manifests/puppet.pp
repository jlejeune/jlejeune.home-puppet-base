#
# Class to configure puppet agent
#

class base::puppet {
  service { 'puppet':
    ensure      =>  running,
  }

  # Set some aliases
  bash::alias { 'p':
    content => 'puppet agent --test',
  }

  bash::alias { 'pe':
    content => 'puppet agent --enable',
  }

  bash::alias { 'pd':
    content => 'puppet agent --disable',
  }
}
