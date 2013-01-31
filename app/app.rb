class RobbinSite < Padrino::Application
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  register Padrino::Rendering
  register Padrino::Helpers
  register WillPaginate::Sinatra

  enable :sessions
  mime_type :md, 'text/plain'

  # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
      
  error ActiveRecord::RecordNotFound do
    halt 404
  end

  error 401 do
    render '401'
  end
  
  error 403 do
    render '403'
  end
  
  error 404 do
    render '404', :layout => 'application'
  end

  error 500 do
    render '500'
  end
end
