class ExerciseConfirmationsController < AjaxController
  include Mumuki::Laboratory::Controllers::NestedInExercise
  include Mumuki::Laboratory::Controllers::ResultsRendering

  def create
    @exercise.submit_confirmation! current_user
    render json: progress_json
  end
end
