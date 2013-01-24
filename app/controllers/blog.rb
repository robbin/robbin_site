RobbinSite.controllers :blog do
  
  get :index do
    @blogs = Blog.order('id DESC').page(params[:page])
    render 'blog/index'
  end
  
  get :show, :map => '/blog/:id', :provides => [:html, :md] do
    @blog = Blog.find params[:id].to_i
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
    content_type :json
    blog = Blog.find params[:id]
    blog.comments.create(:account => current_account, :content => params[:blog_comment][:content])
    "alert('success');"
  end
end
