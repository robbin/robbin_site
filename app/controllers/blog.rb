RobbinSite.controllers :blog do
  
  get :index do
    @blogs = Blog.where(:category => 'blog').order('id DESC').page(params[:page])
    render 'blog/index'
  end
  
  get :note, :map => '/note' do
    @blogs = Blog.where(:category => 'note').order('content_updated_at DESC').page(params[:page])
    render 'blog/note'
  end

  get :tag_cloud, :map => '/tag' do
    render 'blog/tag_cloud'
  end
  
  get :tag, :map => '/tag/:name' do
    @blogs = Blog.tagged_with(params[:name]).order('content_updated_at DESC').page(params[:page])
    if @blogs.blank?
      halt 404      
    else
      render 'blog/tag'      
    end
  end
  
  get :show_url, :map => '/blog/:id/:url', :provides => [:html, :md] do
    @blog = Blog.find params[:id].to_i
    case content_type
    when :md then
      @blog.content
    when :html then
      @blog.increment_view_count
      render 'blog/show'
    end
  end
  
  get :show, :map => '/blog/:id', :provides => [:html, :md] do
    @blog = Blog.find params[:id].to_i
    redirect blog_url(@blog, mime_type = content_type), 301 unless @blog.slug_url.blank?
    case content_type
    when :md then
      @blog.content
    when :html then
      @blog.increment_view_count
      render 'blog/show'
    end
  end
  
  post :create_comment, :map => '/blog/:id/comments' do
    content_type :js
    halt 401 unless account_login?
    blog = Blog.find params[:id]
    halt 403 unless blog.commentable?
    @comment = blog.comments.create(:account => current_account, :content => params[:blog_comment][:content])
    render 'blog/create_comment'
  end
end