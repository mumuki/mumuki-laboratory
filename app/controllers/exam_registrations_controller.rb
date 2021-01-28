class ExamRegistrationsController < ApplicationController
  def show
    @registration = ExamRegistration.find(params[:id])
    @authorization_request = @registration.authorization_request_for(current_user) || ExamAuthorizationRequest.new(exam_registration: @registration)
  end
end
