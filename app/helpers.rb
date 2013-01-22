# Helper methods defined here can be accessed in any controller or view in the application

RobbinSite.helpers do
  
  def current_account
    @account ||= Account.find(session[:account_id]) if session[:account_id]
  end
  
  def account_login?
    if current_account
      return true
    else
      return false
    end
  end
  
  def account_admin?
    if current_account && current_account.admin?
      return true
    else
      return false
    end
  end
end
