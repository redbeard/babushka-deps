dep 'ssh key exists' do
  met? { "#{ENV['HOME']}/.ssh/id_rsa.pub".p.exists? }
  meet { unmeetable! "You must create SSH key for GitHub manually!" }
end

dep 'github known host' do
  met? { !shell('ssh-keyscan github.com').empty? }
  meet { unmeetable! "You must authorize GitHub manually by SSHing to it once." }
end

