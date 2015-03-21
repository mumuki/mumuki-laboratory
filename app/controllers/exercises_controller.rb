class ExercisesController < ApplicationController
  include WithExerciseIndex

  before_action :authenticate!, except: [:index]
  before_action :set_exercises, only: [:index]
  before_action :set_exercise, only: [:show, :edit, :update, :destroy]
  before_action :set_previous_submission_content, only: :show

  def show
    @submission = @exercise.submissions.build
  end

  def index

  end

  def new
    @exercise = Exercise.new(locale: I18n.locale)
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
    @exercise.destroy
    redirect_to exercises_url, notice: 'Exercise was successfully destroyed.'
  end

  private
  def set_previous_submission_content
    @previous_submission_content = @exercise.default_content_for(current_user)
  end


  def set_exercise
    @exercise = Exercise.find(params[:id])
  end

  def exercise_params
    params.require(:exercise).permit(:title, :description, :locale, :test, :extra_code, :language_id, :hint, :tag_list)
  end

  def exercises
    Exercise.at_locale
  end

end
