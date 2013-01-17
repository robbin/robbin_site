RobbinSite.controllers :blog do
  
  get :index do
    @blogs = Blog.all
    render 'blog/index'
  end
  
  get :show, :map => '/blog/:id' do
    @blog = Blog.find params[:id].to_i
    render 'blog/show'
  end

  # get :index, :map => "/foo/bar" do
  #   session[:foo] = "bar"
  #   render 'index'
  # end

  # get :sample, :map => "/sample/url", :provides => [:any, :js] do
  #   case content_type
  #     when :js then ...
  #     else ...
  # end

  # get :foo, :with => :id do
  #   "Maps to url '/foo/#{params[:id]}'"
  # end

  # get "/example" do
  #   "Hello world!"
  # end

  
end
