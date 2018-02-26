class ExerciseConfirmationsController < AjaxController
  include Mumuki::Laboratory::Controllers::NestedInExercise

  def create
    result = @exercise.submit_confirmation! current_user
    render json: result
  end
end
