module WithExerciseIndex

  def index
    @q = Exercise.ransack(params[:q])
    @exercises = paginated @q.result(distinct: true)
    render 'exercises/index'
  end

end
