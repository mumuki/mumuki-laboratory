class GuideExercisesController < ApplicationController
  include WithExerciseIndex

  before_action :set_guide

  private

  def exercises
    @guide.exercises
  end

  def set_guide
    @guide = Guide.find(params[:guide_id])
  end
end
