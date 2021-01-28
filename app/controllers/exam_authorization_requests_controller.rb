class ExamAuthorizationRequestsController < ApplicationController
  def show
    @authorization_request = ExamAuthorizationRequest.find(params[:id])
    Notification.mark_as_read! @authorization_request
  end
end
