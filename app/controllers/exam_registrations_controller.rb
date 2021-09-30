class ExamRegistrationsController < ApplicationController
  def show
    @registration = Organization.current.exam_registrations.find(params[:id])
    @authorization_request = @registration.authorization_request_for(current_user)
  end
end
