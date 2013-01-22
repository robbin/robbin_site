RobbinSite.helpers do
  include ActsAsTaggableOn::TagsHelper
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
end
