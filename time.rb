dep 'ntp.managed'

dep 'ntp service running' do
  met? {
    result = sudo "service ntpd status" # !( /ntpd: unrecognized service/ =~ )
    puts "Result of sudo run: #{result}"
    false
  }
  
  meet {
    sudo "/etc/init.d/ntpd start"
  }
end