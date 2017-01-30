class ExerciseQueryController < ApplicationController
  include NestedInExercise

  before_action :authenticate_api!

  def create
    results = @exercise.submit_query! current_user, query_params
    render json: results
  end

  def query_params
    params.permit(:content, :query, cookie: [])
  end
end
