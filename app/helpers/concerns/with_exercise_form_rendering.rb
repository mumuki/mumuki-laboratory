module WithExerciseFormRendering
  def exercise_form(exercise)
    render "layouts/submissions/editor/#{exercise.class.name.underscore}_form"
  end
end