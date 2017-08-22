class UsersController < ApplicationController
  before_action :authenticate!
  before_action :set_user!

  def show
    @messages = current_user.messages || []
  end

  def update
    current_user.update_and_notify! user_params
    redirect_to root_path, notice: I18n.t(:user_data_updated)
  end

  private

  def validate_user_profile!
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name)
  end

  def set_user!
    @user = current_user
  end
end
