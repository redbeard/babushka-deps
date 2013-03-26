require 'fileutils'

dep( "directory", :dir, :as_sudo ) do
  as_sudo.default(false)

  def directory
    dir.p
  end

  def does_exist?  
     directory.exists?
  end
  
  def is_correct_ownership? 
    (does_exist? && directory.owned?)
  end
  
  met? { 
    log "Directory '#{dir}' #{does_exist? ? "exists #{ is_correct_ownership? ? 'and is' : "but isn't" } owned by the user." : "doesn't exist"}"

    does_exist? && is_correct_ownership?
  }

  meet { 
    unless does_exist?
      log_ok "As sudo? #{as_sudo ? 'Yes' : 'No'}"
      directory.mkpath unless as_sudo
      sudo "mkdir -p '#{dir.to_s}'" if as_sudo
      unmeetable! "Couldn't create directory: '#{dir}'" unless does_exist?
      log_ok "Directory '#{dir}' created successfully."
    end
    
    unless is_correct_ownership? 
      sudo "chown -R #{Process.uid}:#{Process.gid} #{dir}"
      unmeetable "Couldn't change permission for: '#{dir}'" unless is_correct_ownership?
      log_ok "Directory '#{dir}' now owned by user."
    end
  }

end

meta 'dir' do
  accepts_value_for :var_name, :default_var_name
  accepts_value_for :dir, :default_dir
  accepts_value_for :as_sudo, false
  
  def default_var_name
    basename.downcase.gsub(/\W/, '_')
  end
  
  def default_dir
    basename.downcase.gsub(/\.dir/, '').gsub(/(\s|\_)/, '/')
  end
  
  template do
    
    def does_exist?  
       dir.to_s.p.exists?
    end
    
    def is_correct_ownership? 
      (does_exist? && File.owned?(dir.to_s))
    end
    
    met? { 
      set var_name.to_sym, dir.to_s.p
      log_ok "Variable '#{var_name}' set to '#{dir}'."

      log "Directory '#{dir}' #{does_exist? ? "exists #{ is_correct_ownership? ? 'and is' : "but isn't" } owned by the user." : "doesn't exist"}"

      does_exist? && is_correct_ownership?
    }

    meet { 
      unless does_exist?
        FileUtils.mkdir_p(dir.to_s) unless as_sudo
        sudo "mkdir -p '#{dir.to_s}'" if as_sudo
        unmeetable "Couldn't create directory: '#{dir}'" unless does_exist?
        log_ok "Directory '#{dir}' created successfully."
      end
      
      unless is_correct_ownership? 
        sudo "chown -R #{Process.uid}:#{Process.gid} #{dir}"
        unmeetable "Couldn't change permission for: '#{dir}'" unless is_correct_ownership?
        log_ok "Directory '#{dir}' now owned by user."
      end
    }
    
  end
  
end
