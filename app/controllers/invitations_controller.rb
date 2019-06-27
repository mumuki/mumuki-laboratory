class InvitationsController < ApplicationController
  before_action :authenticate!
  before_action :set_invitation!

  skip_before_action :validate_user_profile!
  skip_before_action :authorize_if_private!

  def show
    redirect_to_organization! if current_user.student_of? @invitation.course
  end

  def join
    current_user.accept_invitation! @invitation
    current_user.update! user_params
    current_user.notify!
    redirect_to_organization!
  end

  private

  def redirect_to_organization!
    redirect_to Mumukit::Platform.laboratory.organic_url(@organization)
  end

  def user_params
    params.require(:user).permit(:name, :first_name, :last_name, :email)
  end

  def set_invitation!
    @invitation = Invitation.locate!(params[:code]).unexpired
    @organization = @invitation.organization
  end
end
