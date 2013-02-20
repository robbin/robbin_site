# encoding: utf-8

RobbinSite.controllers :test do

  get :index do
    render 'test/index', :layout => false
  end
  
  post :index do
  end

end
