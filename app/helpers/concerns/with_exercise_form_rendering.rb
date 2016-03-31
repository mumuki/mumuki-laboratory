module WithExerciseFormRendering
  def exercise_form(exercise, options)
    render "layouts/submissions/editor/#{exercise.class.name.underscore}_form", options
  end
end