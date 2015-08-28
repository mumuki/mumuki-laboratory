class ExerciseSolutionsController < ApplicationController
  include NestedInExercise

  before_action :authenticate!

  def create
    @solution = @exercise.submit_solution(current_user, solution_params)
    @solution.run_tests!
    render partial: 'exercise_solutions/results', locals: {solution: @solution}
  end

  private

  def solution_params
    params.require(:solution).permit(:content)
  end
end
