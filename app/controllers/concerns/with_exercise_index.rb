module WithExerciseIndex

  def set_exercises
    @q = params[:q]
    @exercises = paginated exercises.by_full_text(@q).select {|e| e.used_in?(Organization.current).present? }.sort! {|e1, e2| e2.submissions_count <=> e1.submissions_count}
  end

end
