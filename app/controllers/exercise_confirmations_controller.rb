class ExerciseConfirmationsController < AjaxController
  include NestedInExercise

  def create
    result = @exercise.submit_confirmation! current_user
    render json: result.status
  end
end
