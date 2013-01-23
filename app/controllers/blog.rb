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
      Blog.increment_counter(:view_count, @blog.id)
      render 'blog/show'
    end
  end
  
  get :tag, :map => '/tag/:name' do
    @blogs = Blog.tagged_with(params[:name]).order('id DESC').page(params[:page])
    render 'blog/tag'
  end
end
