module WithExerciseFormRendering
  def exercise_form(exercise, options)
    render "layouts/inputs/exercises/#{exercise.class.name.underscore}_form", options
  end

  def editor_form(exercise)
    render "layouts/inputs/exercises/editors/#{exercise.editor}_form"
  end
end
