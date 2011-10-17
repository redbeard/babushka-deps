dep 'ntp.managed'

dep 'ntp service running' do
  met? {
    !(grep /ntpd: unrecognized service/, `service --status-all | grep ntpd`)
  }
  
  meet {
    sudo "/etc/init.d/ntpd start"
  }
end