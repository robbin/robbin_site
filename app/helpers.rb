# Helper methods defined here can be accessed in any controller or view in the application

RobbinSite.helpers do
  
  def current_account
    return Account.find(session[:account_id]) if session[:account_id]
  end
  
  def login?
    if current_account
      return true
    else
      return false
    end
  end
end
