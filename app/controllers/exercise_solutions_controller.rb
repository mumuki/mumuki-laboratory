class ExerciseSolutionsController < AjaxController
  include NestedInExercise
  include WithExamsValidations
  include WithResultsRendering

  before_action :set_messages, only: :create
  before_action :validate_user, only: :create

  def create
    assignment = @exercise.submit_solution!(current_user, solution_params)
    render results_rendering_params(assignment)
  end

  private

  def validate_user
    validate_accessible @exercise.navigable_parent
  end

  def set_messages
    @messages = @exercise.messages_for(current_user)
  end

  def solution_params
    params.require(:solution).tap { |it| it[:content] = params[:solution][:content] }
  end
end
