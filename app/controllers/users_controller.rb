class UsersController < ApplicationController
  before_action :set_user, only: :show

  def show
    @comments = current_user.try(:comments) || []
  end

  private

  def set_user
    @user = current_user
  end
end
