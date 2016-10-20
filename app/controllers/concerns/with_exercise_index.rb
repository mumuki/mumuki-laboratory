module WithExerciseIndex

  def set_exercises
    @q = params[:q]
    @exercises = paginated Exercise.currently_used(@q)
  end

end
