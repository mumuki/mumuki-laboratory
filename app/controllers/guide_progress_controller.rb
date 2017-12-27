class GuideProgressController < ApplicationController
  def destroy
    guide = Guide.find(params[:guide_id])
    guide.clear_progress! current_user
    redirect_back
  end
end
