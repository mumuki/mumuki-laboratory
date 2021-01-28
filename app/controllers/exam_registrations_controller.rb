class ExamRegistrationsController < ApplicationController

  def show
    @exam_registration = ExamRegistration.find(params[:id])
  end
end
