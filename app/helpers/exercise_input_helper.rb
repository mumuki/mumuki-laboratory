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

  def should_render_exercise_tabs?(exercise)
    !exercise.hidden? && (exercise.queriable? || exercise.extra_visible?)
  end

  def submit_button_options(exercise)
    if exercise.upload?
      struct for: :upload,
             tag: :label,
             waiting_t: :uploading_solution,
             fa_icon: :upload,
             t: :upload_solution
    elsif exercise.hidden?
      struct tag: :button,
             classes: 'submission_control',
             waiting_t: :working,
             fa_icon: :play,
             t: :continue_exercise
    else
      struct tag: :button,
             classes: 'submission_control',
             waiting_t: :sending_solution,
             fa_icon: :play,
             t: :create_submission
    end
  end
end
