class UsersController < ApplicationController
  before_action :authenticate!
  before_action :set_user!

  AVATAR_RESOLUTION = '250x250'

  def show
    @messages = current_user.messages.to_a
    @watched_discussions = current_user.watched_discussions_in_organization
  end

  def update
    if avatar.present?
      current_user.avatar.attach avatar
      current_user.image_url = url_for resized_avatar
    end

    current_user.update_and_notify! user_params
    redirect_to root_path, notice: I18n.t(:user_data_updated)
  end

  def unsubscribe
    user_id = User.unsubscription_verifier.verify(params[:id])
    User.find(user_id).unsubscribe_from_reminders!

    redirect_to root_path, notice: t(:unsubscribed_successfully)
  end

  private

  def validate_user_profile!
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :avatar)
  end

  def avatar
    user_params[:avatar]
  end

  def resized_avatar
    current_user.avatar.variant(resize: AVATAR_RESOLUTION).processed
  end

  def set_user!
    @user = current_user
  end
end
