Padrino.configure_apps do
  # enable :sessions
  set :session_secret, 'eb812351848db2c84f8d7805931f5fa3abee0ffb0f00a14f0ac9eadac5be6623'
end

# Mounts the core application for this project
Padrino.mount('RobbinSite').to('/')