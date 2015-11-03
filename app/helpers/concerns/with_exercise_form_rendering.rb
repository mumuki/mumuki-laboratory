module WithExerciseFormRendering
  def exercise_form(exercise, editor_visible=true)
    render "layouts/submissions/editor/#{exercise.class.name.underscore}_form", editor_visible: editor_visible
  end
end