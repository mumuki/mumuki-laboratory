class UsersController < ApplicationController
  before_action :authenticate!
  before_action :set_user!

  def show
    @comments = current_user.comments || []
  end

  private

  def set_user!
    @user = current_user
  end
end
