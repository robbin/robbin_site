# -*- coding: UTF-8 -*-

RobbinSite.controllers :admin do

  before :except => :login do
    if session[:account_id]
      @account = Account.find(session[:account_id])
    else
      halt 403
    end
  end
  
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
  
  get :index do
    render 'admin/index'
  end

  get :new_blog, :map => '/admin/new_blog' do
    @blog = Blog.new
    render 'admin/new_blog'
  end
  
  post :create_blog, :map => '/admin/create_blog' do
    if @blog = Blog.create(params[:blog])
      flash[:notice] = "创建成功"
      redirect url(:blog, :show, :id => @blog.id)
    else
      render 'admin/new_blog'
    end
  end
end
