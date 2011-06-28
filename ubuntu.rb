dep 'multiverse repository enabled' do
  cd(ENV['HOME']) {
    log "Generating multiverse source from '/etc/apt/sources.list'..."
    shell <<CMD
cat /etc/apt/sources.list | grep multiverse | sed -e "s/^# //g" > multiverse.list
CMD
    log "Copying multiverse source to '/etc/apt/sources.list.d/multiverse.list'..."
    sudo "mv multiverse.list /etc/apt/sources.list.d/."
    log "Updating apt-get..."
    sudo "apt-get update"
    log_ok "Update complete."
  }
end
