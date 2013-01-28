RobbinSite.controllers :test do

  get :index do
    render 'test/index'
  end
  
  get :ajax do
    content_type :js
    "$('div#content').html('<h1>OK</h1>');"
  end
  
  post :index do
  end

end
