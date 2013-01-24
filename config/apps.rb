Padrino.configure_apps do
  # enable :sessions
  set :session_secret, APP_CONFIG['session_secret']
end

# Mounts the core application for this project
Padrino.mount('RobbinSite').to('/')