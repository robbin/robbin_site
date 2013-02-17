# encoding: utf-8

RobbinSite.controllers do

  before :login, :weibo_login do
    redirect url(:index) if account_login?
  end
  
  get :index do
    @blogs = Blog.order('id DESC').page(params[:page])
    render 'home/index'
  end
  
  get :weibo do
    render 'home/weibo'
  end
  
  get :me do
    render 'home/me'
  end

  get :search do
    render 'home/search'
  end
  
  get :rss do
    content_type :rss
    @blogs = Blog.order('id DESC').limit(20)
    APP_CACHE.fetch("#{CACHE_PREFIX}/rss/all") { render 'home/rss' }
  end

  # native authentication
  get :login, :map => '/login' do
    @account = Account.new
    render 'home/login'
  end
  
  post :login, :map => '/login' do
    login_tries = APP_CACHE.read("#{CACHE_PREFIX}/login_counter/#{request.ip}")
    halt 401 if login_tries && login_tries.to_i > 5  # reject ip if login tries is over 5 times
    @account = Account.new(params[:account])
    if login_account = Account.authenticate(@account.email, @account.password)
      session[:account_id] = login_account.id
      response.set_cookie('user', {:value => login_account.encrypt_cookie_value, :path => "/", :expires => 2.weeks.since, :httponly => true}) if params[:remember_me]
      redirect url(:index)
    else
      # retry 5 times per one hour
      APP_CACHE.increment("#{CACHE_PREFIX}/login_counter/#{request.ip}", 1, :expires_in => 1.hour)
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

  # weibo authentication
  get :weibo_login do
    session[:quick_login] = true if params[:quick_login]
    redirect WeiboOAuth2::Client.new.authorize_url
  end

  get :weibo_callback do
    client = WeiboOAuth2::Client.new
    if access_token = client.auth_code.get_token(params[:code].to_s)
      weibo_uid = access_token.params["uid"]
      account = Account.where(:provider => 'weibo', :uid => weibo_uid).first
      unless account 
        weibo_user = client.users.show_by_uid(weibo_uid)
        account = Account.create(:provider => 'weibo', :uid => weibo_uid, :name => weibo_user.screen_name, :role => 'commentor')
      end
      session[:account_id] = account.id
      if session[:quick_login]
        session[:quick_login] = nil
        render 'home/weibo_callback', :layout => false
      else
        redirect_to url(:index)
      end
    else
      halt 401
    end
  end

end