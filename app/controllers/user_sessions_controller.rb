class UserSessionsController < ApplicationController
  def new
  end

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to(new_pointcard_path)
    else
      render :new
    end
  end

  def destroy
    logout
    binding.break
    redirect_to login_path, status: :see_other
  end
end
