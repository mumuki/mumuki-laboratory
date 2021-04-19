class ExamAuthorizationRequestsController < ApplicationController
  def show
    @authorization_request = ExamAuthorizationRequest.find(params[:id])
    current_user.read_notification! @authorization_request
  end

  def create
    authorization_request = ExamAuthorizationRequest.create! authorization_request_params
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

  def authorization_request_params
    params
        .require(:exam_authorization_request).permit(:exam_id, :exam_registration_id)
        .merge(user: current_user, organization: Organization.current)
  end
end
