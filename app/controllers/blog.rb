RobbinSite.controllers :blog do
  
  get :index do
    @blogs = Blog.order("id DESC").limit(5)
    render 'blog/index'
  end
  
  get :show, :map => '/blog/:id', :provides => [:html, :md] do
    @blog = Blog.find params[:id].to_i
    case content_type
    when :md then
      @blog.content
    when :html then
      render 'blog/show'
    end
  end
end
