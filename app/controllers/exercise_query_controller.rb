class ExerciseQueryController < AjaxController
  include Mumuki::Laboratory::Controllers::NestedInExercise
  include Mumuki::Laboratory::Controllers::ExerciseSeed

  def create
    results = @exercise.submit_query! current_user, query_params
    render json: results
  end

  def query_params
    params.permit(:content, :query, cookie: [])
  end
end
