class ExerciseSolutionsController < ApplicationController
  include NestedInExercise

  before_action :authenticate!

  def create
    guide_previously_done = guide_done?
    @solution = @exercise.submit_solution(current_user, solution_params)
    @solution.run_tests!
    guide_finished_by_solution = !guide_previously_done && guide_done?
    render partial: 'exercise_solutions/results', locals: {solution: @solution, guide_finished_by_solution: guide_finished_by_solution}
  end

  def guide_done?
    guide = @exercise.guide
    guide && guide.stats_for(current_user).done?
  end

  private

  def solution_params
    params.require(:solution).permit(:content)
  end
end
