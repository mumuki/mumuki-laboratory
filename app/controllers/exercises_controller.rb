class ExercisesController < ApplicationController
  include Mumuki::Laboratory::Controllers::Content
  include Mumuki::Laboratory::Controllers::ExerciseSeed
  include Mumuki::Laboratory::Controllers::ImmersiveNavigation

  before_action :set_parents!, only: :show
  before_action :set_progress!, only: :show, if: :current_user?
  before_action :set_assignment!, only: :show, if: :current_user?

  before_action :validate_accessible!, only: :show
  before_action :start!, only: :show

  def show
    @solution = @exercise.new_solution if current_user?
    enable_embedded_rendering
  end

  def show_transparently
    redirect_to Exercise.find_transparently!(params)
  end

  private

  def subject
    @exercise ||= Exercise.find(params[:id])
  end

  def accessible_subject
    @navigable_parent
  end

  def start!
    @navigable_parent.start! current_user
  end

  def set_assignment!
    @assignment = @exercise.assignment_for(current_user)
    @files = @assignment.files
    @current_content = @assignment.current_content
    @default_content = @assignment.default_content
  end

  def set_parents!
    @guide = @exercise.guide
    @navigable_parent = @exercise.navigable_parent
  end

  def set_progress!
    @stats = @guide.stats_for(current_user)
    @assignments = @guide.assignments_for(current_user)
  end

  def exercise_params
    params.require(:exercise).
      permit(:name, :description, :locale, :test,
             :extra, :language_id, :hint, :tag_list,
             :guide_id, :number,
             :layout, :expectations_yaml)
  end
end
