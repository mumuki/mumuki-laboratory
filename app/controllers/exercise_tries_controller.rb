class ExerciseTriesController < AjaxController
  include NestedInExercise
  include WithResultsRendering

  def create
    results = @exercise.submit_try! current_user, try_params
    @assignment = @exercise.assignment_for current_user
    render json: results.merge(corollary: render_corollary_string)
  end

  private

  def render_corollary_string
    render_to_string(results_rendering_params(@assignment))
  end


  def try_params
    params.permit(:query, cookie: [])
  end
end
