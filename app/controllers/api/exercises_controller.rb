class Api::ExercisesController < Api::BaseController
  def index
    @exercises = Exercise.all
    @exercises = @exercises.where(id: params[:exercises]) if params[:exercises]
    render json: {exercises: @exercises.as_json(only: [:id, :name])}
  end
end
