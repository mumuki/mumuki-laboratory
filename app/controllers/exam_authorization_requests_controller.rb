class ExamAuthorizationRequestsController < ApplicationController
  def create
    authorization_request = ExamAuthorizationRequest.find_or_create_by! create_authorization_request_params do |it|
      it.assign_attributes authorization_request_params
    end
    current_user.read_notification! authorization_request.exam_registration
    flash.notice = I18n.t :exam_authorization_request_created
    redirect_to root_path
  end

  def update
    ExamAuthorizationRequest.update params[:id], authorization_request_params
    flash.notice = I18n.t :exam_authorization_request_saved
    redirect_to root_path
  end

  private

  def create_authorization_request_params
    authorization_request_params.slice :exam_registration_id, :user, :organization
  end

  def authorization_request_params
    params
        .require(:exam_authorization_request).permit(:exam_id, :exam_registration_id)
        .merge(user: current_user, organization: Organization.current)
  end
end
