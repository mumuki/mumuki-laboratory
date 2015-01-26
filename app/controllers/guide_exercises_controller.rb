class GuideExercisesController < ApplicationController
  include WithExerciseIndex
  include NestedInGuide

  before_action :set_exercises, only: :index

  def index
    render 'exercises/index'
  end

  def exercises
    @guide.exercises
  end

end
