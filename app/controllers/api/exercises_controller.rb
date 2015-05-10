class Api::ExercisesController < Api::BaseController
  def index
    @exercises = Exercise.all
    render json: {exercises: @exercises.as_json(only: [:id, :title])}
  end
end
