class RobbinSite < Padrino::Application
  use ActiveRecord::ConnectionAdapters::ConnectionManagement
  register Padrino::Rendering
  register Padrino::Helpers

  enable :sessions
  mime_type :md, 'text/plain'

  # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
  
  get :index do
    @blogs = Blog.order("id DESC").limit(5)
    render 'index'
  end
  
  get :me do
    render 'me'
  end
      
  error ActiveRecord::RecordNotFound do
    halt 404
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
