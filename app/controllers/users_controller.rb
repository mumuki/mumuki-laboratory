class UsersController < ApplicationController
  before_action :authenticate!
  before_action :set_user!

  def show
    @messages = current_user.messages || []
  end

  private

  def set_user!
    @user = current_user
  end
end
