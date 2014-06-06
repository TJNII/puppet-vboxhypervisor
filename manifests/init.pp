# Copyright 2013 Tom Noonan II (TJNII)
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# 
class vboxhypervisor {
  include packagemgrconfig

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

  file { "/etc/default/virtualbox":
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => 644,
    source  => "puppet:///modules/vboxhypervisor/virtualbox.default",
  }        

  service { 'virtualbox':
    ensure    => running,
    enable    => true,
  }
  
}
