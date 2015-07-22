class ExercisesController < ApplicationController
  include WithExerciseIndex

  before_action :authenticate!, except: [:index, :show]
  before_action :set_exercises, only: [:index]
  before_action :set_exercise, only: [:show, :edit, :update, :destroy]
  before_action :set_guide, only: [:show]
  before_action :set_previous_solution_content, only: :show
  before_action :authorize_edition!, only: [:edit, :update]

  def show
    @solution = @exercise.solutions.build if current_user?
  end

  def index

  end

  def new
    @exercise = Exercise.new(locale: I18n.locale, title: params[:q])
  end

  def edit
  end

  def create
    @exercise = current_user.exercises.build(exercise_params)

    if @exercise.save
      redirect_to @exercise, notice: 'Exercise was successfully created.'
    else
      render :new
    end
  end

  def update
    if @exercise.update(exercise_params)
      redirect_to @exercise, notice: 'Exercise was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize_edition!
    @exercise.destroy
    redirect_to exercises_url, notice: 'Exercise was successfully destroyed.'
  end

  private

  def set_previous_solution_content
    @previous_solution_content = @exercise.default_content_for(current_user) if current_user?
  end


  def set_exercise
    @exercise = Exercise.find(params[:id])
  end


  def set_guide
    @guide = @exercise.guide
  end

  def exercise_params
    params.require(:exercise).
        permit(:title, :description, :locale, :test,
               :extra_code, :language_id, :hint, :tag_list,
               :guide_id, :position,
               :layout, :expectations_yaml)
  end

  def exercises
    Exercise.at_locale
  end


  def authorize_edition!
    raise AuthorizationError.new unless @exercise.authored_by?(current_user)
  end
end
