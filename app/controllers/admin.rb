# encoding: utf-8

RobbinSite.controllers :admin do

  before do
    halt 403 unless account_admin?
  end
  
  get :index do
    render 'admin/index'
  end

  get :new_blog, :map => '/admin/blog/new' do
    @blog = Blog.new
    render 'admin/new_blog'
  end
  
  post :blog, :map => '/admin/blog' do
    @blog = Blog.new(params[:blog])
    @blog.account = current_account
    if @blog.save
      flash[:notice] = "创建成功"
      redirect url(:blog, :show, :id => @blog.id)
    else
      render 'admin/new_blog'
    end
  end
  
  get :edit_blog, :map => '/admin/blog/:id/edit' do
    @blog = Blog.find params[:id].to_i
    render 'admin/edit_blog'
  end
  
  put :blog, :map => '/admin/blog/:id' do
    @blog = Blog.find params[:id].to_i
    if @blog.update_blog(params[:blog])
      flash[:notice] = '更新成功'
      redirect url(:blog, :show, :id => @blog.id)
    else
      render 'admin/edit_blog'
    end
  end

  delete :blog, :map => '/admin/blog/:id' do
    @blog = Blog.find params[:id].to_i
    @blog.destroy
    flash[:notice] = "删除成功"
    redirect url(:blog, :index)
  end

  delete :comment, :map => '/admin/comment/:id' do
    content_type :js
    comment = BlogComment.find params[:id]
    comment.destroy
    "$('div#comments>ul>li##{comment.id}').fadeOut('slow');"
  end

end
