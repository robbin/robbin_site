RobbinSite.controllers :blog do
  
  get :index do
    @blogs = Blog.order('id DESC').page(params[:page])
    render 'blog/index'
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
  
  get :tag, :map => '/tag/:name' do
    @blogs = Blog.tagged_with(params[:name]).order('id DESC').page(params[:page])
    unless @blogs.blank?
      render 'blog/tag'
    else
      halt 404
    end
  end
  
  post :create_comment, :map => '/blog/:id/comments' do
    content_type :js
    halt 403 unless account_login?
    blog = Blog.find params[:id]
    @comment = blog.comments.create(:account => current_account, :content => params[:blog_comment][:content])
    render 'blog/create_comment'
  end

end
