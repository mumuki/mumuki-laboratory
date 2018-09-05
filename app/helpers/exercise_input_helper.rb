module ExerciseInputHelper
  def render_exercise_input_layout(exercise)
    render "layouts/exercise_inputs/layouts/#{exercise.layout}", exercise: exercise
  end

  def render_exercise_input_form(exercise)
    render "layouts/exercise_inputs/forms/#{input_form_for(exercise)}_form", exercise: exercise
  end

  def render_exercise_input_editor(form, exercise)
    render "layouts/exercise_inputs/editors/#{exercise.editor}", form: form, exercise: exercise
  end

  def default_content_tag_id(exercise)
    exercise.custom? ? 'mu-custom-editor-default-value' : 'default_content'
  end

  def render_exercise_read_only_editor(exercise, content)
    render "layouts/exercise_inputs/read_only_editors/#{exercise.editor}", exercise: exercise, content: content
  end

  def input_form_for(exercise)
    if exercise&.input_kids?
      'kids'
    else
      exercise.class.name.underscore
    end
  end

  def should_render_exercise_tabs?(exercise, &block)
    !exercise.hidden? && (exercise.queriable? || exercise.extra_visible? || block&.call)
  end

  def should_render_problem_tabs?(exercise, user)
    should_render_exercise_tabs?(exercise) { exercise.has_messages_for? user }
  end

  def should_render_read_only_exercise_tabs?(discussion)
    should_render_exercise_tabs?(discussion.exercise) { discussion.has_submission? }
  end

  def should_render_message_input?(exercise, organization = Organization.current)
    exercise.is_a?(Problem) && !exercise.hidden? && organization.raise_hand_enabled?
  end

  def should_render_need_help_dropdown?(assignment, organization = Organization.current)
    !assignment.passed? && organization.ask_for_help_enabled?
  end

  def render_submit_button(assignment)
    options = submit_button_options(assignment.exercise)
    text = t(options.t) if options.t.present?
    waiting_text = t(options.waiting_t) if options.waiting_t.present?
    %Q{
      <div class="btn-submit-container">
        <#{options.tag} for="#{options.for}"
                       class="btn btn-success btn-block btn-submit #{options.classes}"
                       data-waiting="#{waiting_text}">
          #{fa_icon options.fa_icon}
          #{text} #{remaining_attempts_text(assignment)}
       </#{options.tag}>
      </div>
    }.html_safe
  end

  def remaining_attempts_text(assignment)
    if assignment.limited?
      %Q{
        <span id="attempts-left-text" data-disabled="#{!assignment.attempts_left?}">
          (#{t(:attempts_left, count: assignment.attempts_left)})
        </span>
      }
    end
  end

  def render_custom_editor(exercise, read_only=false)
    custom_editor_tag = "mu-#{exercise.language}-custom-editor"
    "<#{custom_editor_tag} #{custom_editor_read_only if read_only}> </#{custom_editor_tag}>".html_safe
  end

  def custom_editor_read_only
    "read-only=true"
  end

  def input_kids?
    @exercise&.input_kids?
  end

  def exercise_container_type
    input_kids? ? 'container-fluid' : 'container'
  end

  def submit_button_options(exercise)
    if exercise.upload?
      struct for: 'upload-input',
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
    elsif exercise.input_kids?
      struct tag: :button,
             classes: 'submission_control',
             fa_icon: :play
    else
      struct tag: :button,
             classes: 'submission_control',
             waiting_t: :sending_solution,
             fa_icon: :play,
             t: :create_submission
    end
  end
end
