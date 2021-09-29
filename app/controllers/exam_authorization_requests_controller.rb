class ExamAuthorizationRequestsController < ApplicationController

  before_action :set_exam_registration!
  before_action :verify_registration_opened!

  def create
    authorization_request = @exam_registration.authorization_requests.find_or_create_by! create_authorization_request_params do |it|
      it.assign_attributes authorization_request_params
    end
    current_user.read_notification! authorization_request.exam_registration
    flash.notice = I18n.t :exam_authorization_request_created
    redirect_to root_path
  end

  def update
    @exam_registration.authorization_requests.update params[:id], authorization_request_params
    flash.notice = I18n.t :exam_authorization_request_saved
    redirect_to root_path
  end

  private

  def create_authorization_request_params
    authorization_request_params.slice :user, :organization
  end

  def authorization_request_params
    params
        .require(:exam_authorization_request).permit(:exam_id, :exam_registration_id)
        .merge(user: current_user, organization: Organization.current)
  end

  def set_exam_registration!
    @exam_registration = ExamRegistration.find(authorization_request_params[:exam_registration_id])
  end

  def verify_registration_opened!
    raise Mumuki::Domain::GoneError if @exam_registration.ended?
  end
end
