class ExercisesController < ApplicationController
  include WithExerciseIndex
  include WithExamsValidations

  before_action :set_exercises, only: :index
  before_action :set_guide, only: :show
  before_action :set_default_content, only: :show, if: :current_user?
  before_action :set_comments, only: :show
  before_action :validate_user, only: :show
  before_action :start!, only: :show

  def show
    @solution = @exercise.new_solution if current_user?
  end

  def index
  end

  private

  def subject
    @exercise ||= Exercise.find_by(id: params[:id])
  end

  def validate_user
    validate_accessible @exercise.navigable_parent
  end

  def start!
    @exercise.navigable_parent.start! current_user
  end

  def set_default_content
    @current_content = @exercise.current_content_for(current_user)
    @default_content = @exercise.default_content_for(current_user)
  end

  def set_comments
    @comments = @exercise.comments_for(current_user) if current_user?
    @comments.try(:each, &:read!)
  end

  def set_guide
    @guide = @exercise.guide
  end

  def exercise_params
    params.require(:exercise).
        permit(:name, :description, :locale, :test,
               :extra, :language_id, :hint, :tag_list,
               :guide_id, :number,
               :layout, :expectations_yaml)
  end

  def exercises
    Exercise.all
  end
end
