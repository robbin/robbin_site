Admin.controllers :accounts do
  before do
    settings.breadcrumbs.reset
    settings.breadcrumbs.add :account, url(:accounts, :index), :account
  end

  get :index do
    @accounts = Account.all
    render 'accounts/index'
  end

  get :new do
    settings.breadcrumbs.add :account_new , url(:accounts, :new), :new
    @account = Account.new
    render 'accounts/new'
  end

  post :create do
    @account = Account.new(params[:account])
    if @account.save
      flash[:notice] = 'Account was successfully created.'
      params[:save_and_continue] ? redirect(url(:accounts, :index)) : redirect(url(:accounts, :edit, :id => @account.id))
    else
      render 'accounts/new'
    end
  end

  get :edit, :with => :id do
    settings.breadcrumbs.add :account_edit, params[:id],  :edit
    @account = Account.find(params[:id])
    if @account
      render 'accounts/edit'
    else
      halt 404
    end
  end

  put :update, :with => :id do
    @account = Account.find(params[:id])
    if @account
      if @account.update_attributes(params[:account])
        flash[:notice] = 'Account was successfully updated.'
        params[:save_and_continue] ? redirect(url(:accounts, :index)) : redirect(url(:accounts, :edit, :id => @account.id))
      else
        render 'accounts/edit'
      end
    else
      halt 404
    end
  end

  delete :destroy, :with => :id do
    account = Account.find(params[:id])
    if account
      if account != current_account && account.destroy
        flash[:notice] = 'Account was successfully destroyed.'
      else
        flash[:error] = 'Unable to destroy Account!'
      end
      redirect url(:accounts, :index)
    else
      halt 404
    end
  end

  delete :delete_multiple do
    unless params[:account_ids]
      flash[:error] = 'You must select at least one account '
      redirect(url(:accounts, :index))
    end
    accounts = Account.find(params[:account_ids])
    if Account.destroy accounts
      flash[:notice] = 'accounts have been successfully destroyed.'
    end
    redirect url(:accounts, :index)
  end
end
