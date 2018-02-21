class ExerciseTriesController < AjaxController
  include NestedInExercise
  include WithResultsRendering

  def create
    assignment, results = @exercise.submit_try! current_user, try_params
    render json: results.merge(corollary: render_corollary_string(assignment))
  end

  private

  def render_corollary_string(assignment)
    render_results(assignment)
  end


  def try_params
    params.permit(:query, cookie: [])
  end
end
