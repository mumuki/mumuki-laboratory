class UsersController < ApplicationController
  include WithUserParams

  before_action :authenticate!
  before_action :set_user!

  def show
    @messages = current_user.messages.to_a
    @watched_discussions = current_user.watched_discussions_in_organization
  end

  def update
    current_user.update_and_notify! user_params
    redirect_to user_path, notice: I18n.t(:user_data_updated)
  end

  def unsubscribe
    user_id = User.unsubscription_verifier.verify(params[:id])
    User.find(user_id).unsubscribe_from_reminders!

    redirect_to root_path, notice: t(:unsubscribed_successfully)
  end

  def permissible_params
    super << :avatar_id
  end

  private

  def validate_user_profile!
  end

  def set_user!
    @user = current_user
  end
end
