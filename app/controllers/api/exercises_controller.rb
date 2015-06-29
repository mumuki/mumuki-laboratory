class Api::ExercisesController < Api::BaseController
  def index
    @exercises = Exercise.all
    @exercises = @exercises.where(id: params[:exercises]) if params[:exercises]
    render json: {exercises: @exercises.as_json(only: [:id, :title])}
  end

  def show
    @exercise = Exercise.find(params[:id])
    render json: @exercise
  end
end
