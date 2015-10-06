class ExerciseQueryController < ApplicationController
  include NestedInExercise

  before_action :authenticate!

  def create
    results = @exercise.submit_query! current_user, query_params
    render json: results
  end

  def query_params
    params.permit(:content, :query)
  end
end
