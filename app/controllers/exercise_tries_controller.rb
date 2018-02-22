class ExerciseTriesController < AjaxController
  include NestedInExercise
  include WithResultsRendering

  def create
    assignment, results = @exercise.submit_try! current_user, try_params
    render_results_json assignment, results
  end

  private

  def try_params
    params.permit(:query, cookie: [])
  end
end
