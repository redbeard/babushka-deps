dep 'ntp.managed'

dep 'ntp service running' do
  def ntp_is_configued?
    !(grep /ntpd: unrecognized service/, `service --status-all | grep ntpd`)
  end
  
  met? {
    ntp_is_configured?
  }
  
  meet {
    sudo "/etc/init.d/ntpd start"
  }
end