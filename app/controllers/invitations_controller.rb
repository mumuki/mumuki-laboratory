class InvitationsController < ApplicationController
  before_action :authenticate!
  before_action :set_invitation!

  def show
    redirect_to_organization! if current_user.student_of? @organization
  end

  def join
    current_user.make_student_of! @invitation.course
    current_user.update! user_params
    current_user.notify!
    redirect_to_organization!
  end

  def authorize_if_private!
    # This controller must never be authenticated
  end

  private

  def redirect_to_organization!
    redirect_to Mumukit::Platform.laboratory.organic_url @organization
  end

  def user_params
    params.require(:user).permit(:name, :first_name, :last_name, :email)
  end

  def set_invitation!
    @invitation = Invitation.find_by_code params[:code]
    @organization = @invitation.organization
  end
end
