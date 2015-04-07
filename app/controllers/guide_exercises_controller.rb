class GuideExercisesController < ApplicationController
  include NestedInGuide

  before_action :authenticate!

  def index
    @exercises = paginated @guide.exercises
  end

end
