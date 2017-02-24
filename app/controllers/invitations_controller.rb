class InvitationsController < ApplicationController
  before_action :authenticate!
  before_action :set_invitation!

  def show
    redirect_to_organization! if current_user.student_of? @organization
  end

  def join
    current_user.make_student_of! @invitation.course
    current_user.update! user_params
    current_user.notify_changed!
    redirect_to_organization!
  end

  private

  def redirect_to_organization!
    redirect_to ApplicationRoot.laboratory.url_for(@organization.name)
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end

  def set_invitation!
    @invitation = Invitation.find_by_slug params[:invitation]
    @organization = @invitation.organization
  end
end
