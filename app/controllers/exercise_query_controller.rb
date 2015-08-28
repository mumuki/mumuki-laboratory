class ExerciseQueryController < ApplicationController
  include NestedInExercise

  before_action :authenticate!

  def create
    @query = @exercise.submit_query!(query_params)
    @query.run!
    render partial: 'exercise_queries/results', locals: {query: @query}
  end

  def solution_params
    params.permit(:content, :query)
  end
end
