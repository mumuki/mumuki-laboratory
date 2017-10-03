class ExerciseStepsController < AjaxController
  include NestedInExercise

  def create
    results = @exercise.submit_step! current_user, step_params
    render json: results
  end

  def step_params
    params.permit(:query, cookie: [])
  end
end
