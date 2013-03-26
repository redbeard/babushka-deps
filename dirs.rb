require 'fileutils'

dep( "directory", :dir, :creation_method ) do
  creation_method.default!(:not_sudo)

  def directory
    dir.p
  end

  def does_exist?  
     directory.exists?
  end
  
  def is_correct_ownership? 
    (does_exist? && directory.owned?)
  end

  def as_sudo?
    creation_method == :as_sudo
  end
  
  met? { 
    log "Directory '#{dir}' #{does_exist? ? "exists #{ is_correct_ownership? ? 'and is' : "but isn't" } owned by the user." : "doesn't exist"}"

    does_exist? && is_correct_ownership?
  }

  meet { 
    unless does_exist?
      directory.mkpath unless as_sudo?
      sudo "mkdir -p '#{dir.to_s}'" if as_sudo?
      unmeetable! "Couldn't create directory: '#{dir}'" unless does_exist?
      log_ok "Directory '#{dir}' created successfully#{as_sudo? ? ' using sudo' : ''}."
    end
    
    unless is_correct_ownership? 
      sudo "chown -R #{Process.uid}:#{Process.gid} #{dir}"
      unmeetable! "Couldn't change permission for: '#{dir}'" unless is_correct_ownership?
      log_ok "Directory '#{dir}' now owned by user."
    end
  }

end
