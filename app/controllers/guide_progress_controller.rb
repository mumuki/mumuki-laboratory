class GuideProgressController < ApplicationController
  before_action :check_not_in_exam!

  def destroy
    guide.clear_progress! current_user
    redirect_back fallback_location: url_for(guide)
  end

  private

  def check_not_in_exam!
    raise Mumuki::Laboratory::ForbiddenError if guide.exam_in_organization?
  end

  def guide
    @guide ||= Guide.find(params[:guide_id])
  end
end
