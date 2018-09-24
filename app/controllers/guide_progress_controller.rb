class GuideProgressController < ApplicationController
  before_action :check_resettable!, only: :destroy

  def destroy
    guide.clear_progress! current_user
    redirect_back fallback_location: url_for(guide)
  end

  private

  def check_resettable!
    raise Mumuki::Laboratory::ForbiddenError unless guide.resettable?
  end

  def guide
    @guide ||= Guide.find(params[:guide_id])
  end
end
