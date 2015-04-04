class UsersController < ApplicationController
  before_action :set_user, only: :show

  def show
  end

  def index
    @users = paginated User.all
  end
  private

  def set_user
    @user = User.find(params[:id])
  end
end
