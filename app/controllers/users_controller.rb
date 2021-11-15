class UsersController < ApplicationController
  include WithUserParams

  before_action :authenticate!, except: :terms
  before_action :set_user!
  before_action :set_notification!, only: :toggle_read
  before_action :verify_owns_notification!, only: :toggle_read
  skip_before_action :validate_accepted_role_terms!

  def update
    current_user.update_and_notify! user_params
    current_user.accept_profile_terms!
    flash.notice = I18n.t(:user_data_updated)
    redirect_after! :profile_completion, fallback_location: user_path
  end

  def accept_profile_terms
    current_user.accept_profile_terms!
    flash.notice = I18n.t(:terms_accepted)
    redirect_after! :terms_acceptance, fallback_location: root_path
  end

  def terms
    @profile_terms ||= Term.profile_terms_for(current_user)
  end

  def messages
    @messages ||= current_user.messages_in_organization
  end

  def discussions
    @watched_discussions = current_user.watched_discussions_in_organization
                                       .where(exercise: Organization.current.exercises)
                                       .scoped_query_by(discussion_filter_params)
                                       .unread_first
  end

  def activity
    @activity = UserStats.stats_for(current_user).activity date_range_params
  end

  def certificates
    @certificates ||= current_user.certificates_in_organization
  end

  def exam_authorizations
    @exam_authorization_requests ||= ExamAuthorizationRequest.where(user: current_user, organization: Organization.current)
  end

  def send_delete_confirmation_email
    current_user.generate_delete_account_token!
    UserMailer.delete_account(current_user).post!
    redirect_to delete_request_user_path
  end

  def delete_confirmation
    return redirect_to delete_confirmation_invalid_user_path unless @user.delete_account_token_matches? params[:token]

    @user.destroy!

    redirect_to logout_path, notice: I18n.t(:user_deleted_successfully)
  end

  def permissible_params
    super << [:avatar_id, :avatar_type]
  end

  def notifications
    @notifications = @user.notifications_in_organization.order(:read, created_at: :desc).page(params[:page]).per(10)
  end

  def toggle_read
    @notification.toggle! :read
    redirect_to notifications_user_path
  end

  def show_manage_notifications
    render 'manage_notifications'
  end

  def manage_notifications
    @user.update! ignored_notifications: manage_notifications_params.reject { |_, allowed| allowed.to_boolean }.keys

    redirect_to notifications_user_path, notice: I18n.t(:preferences_updated_successfully)
  end

  private

  def manage_notifications_params
    params.require(:notifications)
  end

  def set_notification!
    @notification = Notification.find(params[:id])
  end

  def verify_owns_notification!
    raise Mumuki::Domain::NotFoundError unless @notification.user == @user
  end

  def validate_user_profile!
  end

  def set_user!
    @user = current_user
  end

  def date_range_params
    @date_from = params[:date_from].try { |it| Date.parse it }
    to = params[:date_to].try { |it| Date.parse it }
    if @date_from && to
      @date_from.beginning_of_day..(to - 1.day).end_of_day
    else
      nil
    end
  end

  def discussion_filter_params
    @filter_params ||= params.permit([:page])
  end

  def authorization_minimum_role
    :ex_student
  end
end
