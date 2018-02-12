class ExerciseTriesController < AjaxController
  include Mumuki::Laboratory::Controllers::NestedInExercise
  include Mumuki::Laboratory::Controllers::ResultsRendering

  def create
    assignment, results = @exercise.submit_try! current_user, try_params
    render_results_json assignment, results
  end

  private

  def try_params
    params.permit(:query, cookie: [])
  end
end
