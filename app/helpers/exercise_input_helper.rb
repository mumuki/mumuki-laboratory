module ExerciseInputHelper
  def render_exercise_input_layout(exercise)
    render "layouts/exercise_inputs/layouts/#{exercise.layout}"
  end

  def render_exercise_input_form(exercise)
    render "layouts/exercise_inputs/forms/#{exercise.class.name.underscore}_form"
  end

  def render_exercise_input_editor(form, exercise)
    render "layouts/exercise_inputs/editors/#{exercise.editor}", form: form
  end
end
