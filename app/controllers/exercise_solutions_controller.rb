class ExerciseSolutionsController < ApplicationController
  before_action :authenticate!

  before_action :set_exercise, only: [:create]

  def create
    @solution = @exercise.submit_solution(current_user, solution_params)
    @solution.run_tests!
    render partial: 'exercise_solutions/results', locals: {solution: @solution}
  end

  private

  def set_exercise
    @exercise = Exercise.find(params[:exercise_id])
  end

  def solution_params
    params.require(:solution).permit(:content)
  end
end
