dep 'ntp.managed' do
  provides 'ntpdate'
end

dep 'ntp installed' do
  requires_when_unmet 'ntp.managed'
  
  met? {
    which 'ntpdate'
  }
  
  meet {
    sudo 'chkconfig ntpd on'
  }
end

dep 'system clock synchronised' do
  requires 'ntp installed'
  
  meet {
    sudo 'ntpdate pool.ntp.org'
  }
end

dep 'ntp service running' do
  requires_when_unmet 'ntp installed', 'system clock synchronised'
  
  met? {
    sudo "service ntpd status" # !( /ntpd: unrecognized service/ =~ )
  }
  
  meet {
    sudo "/etc/init.d/ntpd start"
  }
end