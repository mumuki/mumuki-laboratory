class Api::ExercisesController < Api::BaseController
  def index
    render json: {exercises: []}
  end
end
