class UsersController < ApplicationController
  before_action :set_user, only: :show

  def show
    @comments = current_user.try(:comments) || []
  end

  def index
    @q = params[:q]
    @users = paginated User.by_full_text(@q).order('last_submission_date desc nulls last'), 30
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
