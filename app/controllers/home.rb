# encoding: utf-8

RobbinSite.controllers do

  before :login do
    redirect url(:index) if account_login?
  end
  
  get :index do
    @blogs = Blog.order('id DESC').page(params[:page])
    render 'home/index'
  end
  
  get :me do
    render 'home/me'
  end
  
  get :login, :map => '/login' do
    @account = Account.new
    render 'home/login'
  end
  
  post :login, :map => '/login' do
    @account = Account.new(params[:account])
    if login_account = Account.authenticate(@account.email, @account.password)
      session[:account_id] = login_account.id
      response.set_cookie('user', {:value => login_account.encrypt_cookie_value, :path => "/", :expires => 2.weeks.since, :httponly => true}) if params[:remember_me]
      redirect url(:index)
    else
      render 'home/login'
    end
  end

  delete :logout, :map => '/logout' do
    if account_login?
      session[:account_id] = nil
      response.delete_cookie("user")
      flash[:notice] = "成功退出"
    end
    redirect url(:index)
  end

end
