module WithExerciseIndex

  def index
    @exercises = Exercise.all
    render 'exercises/index'
  end

end
