class InvitationsController < ApplicationController
  include WithUserParams

  before_action :authenticate!
  before_action :set_invitation!
  before_action :set_user!

  skip_before_action :validate_user_profile!
  skip_before_action :validate_accepted_role_terms!
  skip_before_action :authorize_if_private!
  skip_before_action :validate_active_organization!

  def show
    redirect_to_organization! if current_user.student_of? @invitation.course
  end

  def join
    current_user.accept_invitation! @invitation
    current_user.update_and_notify! user_params
    redirect_to_organization!
  end

  private

  def redirect_to_organization!
    redirect_to Mumukit::Platform.laboratory.organic_url(@organization)
  end

  def permissible_params
    super + [:email, :name]
  end

  def set_invitation!
    @invitation = Invitation.locate!(params[:code]).unexpired
    @organization = @invitation.organization
  end

  def set_user!
    @user = current_user
  end
end
