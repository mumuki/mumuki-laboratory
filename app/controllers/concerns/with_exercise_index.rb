module WithExerciseIndex

  def set_exercises
    @q = params[:q]
    @exercises = paginated exercises.by_full_text(@q).reorder(submissions_count: :desc), 3
  end

end
