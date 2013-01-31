RobbinSite.helpers do
  def current_account
    return @current_account if @current_account
    return @current_account = Account.find_by_id(session[:account_id]) if session[:account_id]
    if request.cookies['user'] && (@current_account = Account.validate_cookie(request.cookies['user']))
      session[:account_id] = @current_account.id
      return @current_account
    end
  end
  
  def account_login?
    current_account ? true : false
  end
  
  def account_admin?
    current_account && current_account.admin? ? true : false
  end
  
  def blog_url(blog, mime_type = :html)
    if blog.slug_url.blank?
      slug_url = url(:blog, :show, :id => blog.id)
    else
      slug_url = url(:blog, :show_url, :id => blog.id, :url => blog.slug_url)
    end
    slug_url << "." << mime_type.to_s if mime_type != :html
    slug_url
  end
end
