class GuideExercisesController < ApplicationController
  before_action :set_guide

  def index
    #TODO duplicated logic in exercise controller
    @exercises  = paginated @guide.exercises.by_tag params[:tag]
    render 'exercises/index'

  end

  private

  def set_guide
    @guide = Guide.find(params[:guide_id])
  end
end
