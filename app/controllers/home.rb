# encoding: utf-8

RobbinSite.controllers do

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
      redirect url(:index)
    else
      render 'home/login'
    end
  end
  
  delete :logout, :map => '/logout' do
    if session[:account_id] && Account.find(session[:account_id])
      session[:account_id] = nil
      flash[:notice] = "成功退出"
    end
    redirect url(:index)
  end

end
