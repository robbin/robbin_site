RobbinSite.helpers do
  def current_account
    @account ||= Account.find(session[:account_id]) if session[:account_id]
  end
  
  def account_login?
    current_account ? true : false
  end
  
  def account_admin?
    if current_account && current_account.admin?
      return true
    else
      return false
    end
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
