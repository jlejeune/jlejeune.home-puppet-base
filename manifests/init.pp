#
# Base module to install all basic stuff
#

class base {
  # Packages
  package { 'ccze':
    ensure  => latest,
  }
  package { 'jq':
    ensure  => latest,
  }
  package { 'lnav':
    ensure  => latest,
  }
  bash::alias { 'j':
    content => 'python -mjson.tool| pygmentize -l json',
  }
}
