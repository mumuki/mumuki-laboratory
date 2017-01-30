class ExerciseSolutionsController < ApplicationController
  include NestedInExercise
  include WithExamsValidations

  before_action :authenticate_api!
  before_action :set_guide_previously_done
  before_action :set_comments, only: :create
  before_action :validate_user, only: :create

  def create
    assignment = @exercise.submit_solution!(current_user, solution_params)
    render partial: 'exercise_solutions/results',
           locals: {assignment: assignment,
                    guide_finished_by_solution: guide_finished_by_solution?}
  end

  private

  def validate_user
    validate_accessible @exercise.navigable_parent
  end

  def guide_finished_by_solution?
    !@guide_previously_done && @exercise.guide_done_for?(current_user)
  end

  def set_guide_previously_done
    @guide_previously_done = @exercise.guide_done_for?(current_user)
  end

  def set_comments
    @comments = @exercise.comments_for(current_user)
  end

  def solution_params
    params.require(:solution).permit(:content)
  end
end
