class ExerciseTriesController < AjaxController
  include NestedInExercise

  def create
    results = @exercise.submit_try! current_user, try_params
    render json: results
  end

  def try_params
    params.permit(:query, cookie: [])
  end
end
