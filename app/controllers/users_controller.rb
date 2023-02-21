class UsersController < ApplicationController
  def show
  end

  def new
    @user = User.new
  end

  def create
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
  end

  def destroy
  end
end
