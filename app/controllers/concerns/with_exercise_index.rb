module WithExerciseIndex

  def set_exercises
    @q = params[:q]
    @exercises = paginated Exercise.by_full_text(@q).reorder(submissions_count: :desc)
  end

end
