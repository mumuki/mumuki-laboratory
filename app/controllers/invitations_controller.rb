class InvitationsController < ApplicationController
  before_action :authenticate!
  before_action :set_user!
  before_action :set_invitation!

  def show
    redirect_to_organization! if @user.student_of? @organization
  end

  def join
    @user.make_student_of! @invitation.course
    @user.update! user_params
    @user.notify_changed!
    redirect_to_organization!
  end

  private

  def redirect_to_organization!
    redirect_to "#{ApplicationRoot.laboratory.url}/#{@organization.name}"
  end

  def user_params
    params.require(:user).permit(:name, :email)
  end

  def set_user!
    @user = current_user
  end

  def set_invitation!
    @invitation = Invitation.find_by_slug params[:invitation]
    @organization = @invitation.organization
  end
end
