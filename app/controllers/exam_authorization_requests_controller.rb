class ExamAuthorizationRequestsController < ApplicationController

  before_action :set_registration!
  before_action :verify_registration_opened!
  before_action :verify_registration_in_current_organization!

  def create
    authorization_request = @registration.authorization_requests.find_or_create_by! user: current_user do |it|
      it.assign_attributes user: current_user,
                           organization: @registration.organization,
                           exam_id: authorization_request_params[:exam_id]
    end
    current_user.read_notification! @registration
    flash.notice = I18n.t :exam_authorization_request_created
    redirect_to root_path
  end

  def update
    @registration.authorization_requests.update params[:id], exam_id: authorization_request_params[:exam_id]
    flash.notice = I18n.t :exam_authorization_request_saved
    redirect_to root_path
  end

  private

  def authorization_request_params
    params.require(:exam_authorization_request).permit(:exam_id, :exam_registration_id)
  end

  def set_registration!
    @registration = ExamRegistration.find(authorization_request_params[:exam_registration_id])
  end

  def verify_registration_in_current_organization!
    raise Mumuki::Domain::NotFoundError unless @registration.organization == Organization.current
  end

  def verify_registration_opened!
    raise Mumuki::Domain::GoneError if @registration.ended?
  end
end
