class ExercisesController < ApplicationController
  include WithExerciseIndex

  before_action :authenticate!, except: [:index, :show]
  before_action :set_exercises, only: [:index]
  before_action :set_exercise, only: :show
  before_action :set_guide, only: [:show]
  before_action :set_previous_solution, only: :show

  def show
    @solution = @exercise.new_solution if current_user?
  end

  def index
  end

  private

  def subject
    @exercise
  end

  def set_previous_solution
    @previous_solution = @exercise.previous_solution_for(current_user) if current_user?
  end


  def set_exercise
    @exercise = Exercise.find(params[:id])
  end


  def set_guide
    @guide = @exercise.guide
  end

  def exercise_params
    params.require(:exercise).
        permit(:name, :description, :locale, :test,
               :extra_code, :language_id, :hint, :tag_list,
               :guide_id, :position,
               :layout, :expectations_yaml)
  end

  def exercises
    Exercise.all
  end
end
