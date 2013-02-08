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
    @attachments = current_account.attachments.where(:blog_id => nil)
    render 'admin/new_blog'
  end
  
  post :blog, :map => '/admin/blog' do
    @blog = Blog.new(params[:blog])
    @blog.account = current_account
    if @blog.save
      @blog.attach!(current_account)
      flash[:notice] = "创建成功"
      redirect url(:blog, :show, :id => @blog.id)
    else
      render 'admin/new_blog'
    end
  end
  
  get :edit_blog, :map => '/admin/blog/:id/edit' do
    @blog = Blog.find params[:id].to_i
    @attachments = current_account.attachments.where(:blog_id => [nil, @blog.id])
    render 'admin/edit_blog'
  end
  
  put :blog, :map => '/admin/blog/:id' do
    @blog = Blog.find params[:id].to_i
    if @blog.update_blog(params[:blog])
      @blog.attach!(current_account)
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
    "$('div#comments>ul>li##{comment.id}').fadeOut('slow').remove();"
  end

  get :new_attachment, :map => '/admin/attachment/new' do
    @attachment = Attachment.new
    render 'admin/new_attachment', :layout => false
  end
  
  get :attachment, :map => '/admin/attachment/:id' do
    @attachment = Attachment.find params[:id]
    render 'admin/attachment', :layout => false
  end
  
  post :create_attachment, :map => '/admin/attachment' do
    attachment = Attachment.new(params[:attachment])
    attachment.account = current_account
    if attachment.save
      redirect_to url(:admin, :attachment, :id => attachment.id)
    else
      render 'admin/attachment_fail', :layout => false
    end
  end
  
  delete :attachment, :map => '/admin/attachment/:id' do
    content_type :js
    @attachment = Attachment.find params[:id]
    @attachment.destroy
    "$('#attachment_#{@attachment.id}').html('<del> #{@attachment.file} 附件已被删除</del>')"
  end
end
