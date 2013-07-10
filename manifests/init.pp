class vboxhypervisor {
  file { "/etc/apt.conf":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 644,
    source  => "puppet:///modules/vboxhypervisor/apt.conf",
  }        

  package { 'linux-headers-amd64':
    ensure  => installed,
  }
  
  package { [ 'virtualbox-ose',
              'virtualbox-dkms',
              'virtualbox-source',
              ]:
    ensure  => installed,
    require => [ File["/etc/apt.conf"],
                 Package["linux-headers-amd64"],
                 ],
  }

  # User/group/homedir
  group { 'vBox':
    ensure => 'present',
  }
  
  user { 'vboxmgr':
    shell   => '/bin/bash',
    groups  => ['vBox'],
    ensure  => 'present',
    require => Group["vBox"],
    home    => '/mnt/vBox',
  }

  # NOTE: Package currently does not ensure mounting
  file { '/mnt/vBox':
    ensure => directory,
    owner   => 'vboxmgr',
    group   => 'vBox',
    mode    => 640,
  }

  ## Need /etc/default/virtualbox config

  ## Need virtualbox service
  
}
