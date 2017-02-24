class InvitationsController < ApplicationController
  before_action :authenticate!
  before_action :set_user!
  before_action :set_invitation!

  def show
  end

  def join
  end

  def set_user!
    @user = current_user
  end

  def set_invitation!
    @invitation = Invitation.find_by_slug params[:invitation]
    @organization = @invitation.organization
  end
end
