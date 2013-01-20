RobbinSite.controllers :admin do

  get :login, :map => '/login' do
    @account = Account.new
    render 'admin/login'
  end
  
  post :login, :map => '/login' do
    @account = Account.new(params[:account])
    if login_account = Account.authenticate(@account.email, @account.password)
      session[:account_id] = login_account.id
      redirect url(:index)
    else
      render 'admin/login'
    end
  end
  
  delete :logout, :map => '/logout' do
    if account = Account.find(session[:account_id])
      session[:account_id] = nil
    end
    redirect url(:index)
  end

end
