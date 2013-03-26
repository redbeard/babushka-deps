require 'fileutils'

dep("directory-exists", :dir, :creation_method) do
  creation_method.default!(:not_sudo)

  def directory
    dir.p
  end

  def does_exist?  
     directory.exists?
  end
  
  def as_sudo?
    creation_method == :sudo
  end

  met? { 
    log "Directory '#{dir}' #{does_exist? ? "exists" : "doesn't exist"}."

    does_exist?
  }

  meet { 
    directory.mkpath unless as_sudo?
    sudo "mkdir -p '#{dir.to_s}'" if as_sudo?
    unmeetable! "Couldn't create directory: '#{dir}'" unless does_exist?
    log_ok "Directory '#{dir}' created successfully#{as_sudo? ? ' using sudo' : ''}."
  }  
end

dep("directory-has-correct-ownership", :dir, :username, :group) do
  requires_when_unmet 'politburo:user-exists'.with(username: username, group: group)
  
  username.default!(ENV['USER'])
  group.default!(ENV['USER'])

  def directory
    dir.p
  end

  def does_exist?  
     directory.exists?
  end

  def is_correct_ownership? 
    return false unless does_exist?

    require 'etc'
    stat = directory.stat

    dir_username = Etc.getpwuid(stat.uid).name
    dir_group = Etc.getgrgid(stat.gid).name

    (dir_username === username) and (dir_group === group)
  end

  met? {
    log "Directory '#{dir}' #{ is_correct_ownership? ? 'is' : "isn't" } owned by #{username}:#{group}."

    is_correct_ownership?    
  }

  meet {
    sudo "chown -R #{username}:#{group} #{dir}"
    unmeetable! "Couldn't change permission for: '#{dir}'" unless is_correct_ownership?
    log_ok "Directory '#{dir}' now owned by #{username}:#{group}."
  }
end


dep( "directory", :dir, :creation_method, :username, :group ) do
  requires 'directory-exists'.with(dir: dir, creation_method: creation_method),
    'directory-has-correct-ownership'.with(dir: dir, username: username, group: group)

end
