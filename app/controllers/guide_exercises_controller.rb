class GuideExercisesController < ApplicationController
  include WithExerciseIndex
  include NestedInGuide

  def exercises
    @guide.exercises
  end

end
