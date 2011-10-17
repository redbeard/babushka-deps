dep 'ntp.managed'

dep 'ntp service running' do
  met? {
    sudo "service ntpd status" # !( /ntpd: unrecognized service/ =~ )
  }
  
  meet {
    sudo "/etc/init.d/ntpd start"
  }
end