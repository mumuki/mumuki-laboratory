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

  def should_render_message_input?(exercise, organization = Organization.current)
    exercise.is_a?(Problem) && !exercise.hidden? && organization.raise_hand_enabled?
  end

  def should_render_need_help_dropdown?(assignment, organization = Organization.current)
    !assignment.solved? && organization.ask_for_help_enabled?(assignment.submitter)
  end

  def render_submit_button(assignment)
    options = submit_button_options(assignment.exercise)
    text = t(options.t) if options.t.present?
    waiting_text = t(options.waiting_t) if options.waiting_t.present?
    %Q{
      <div class="btn-submit-container">
        <button class="btn btn-complementary w-100 btn-submit #{options.classes}"
                       data-waiting="#{waiting_text}">
          #{fa_icon 'play', text: ([text, remaining_attempts_text(assignment)].join('')).html_safe}
       </button>
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
    "<#{custom_editor_tag} id='#{custom_editor_tag}' class='#{custom_editor_tag}' #{custom_editor_read_only if read_only}> </#{custom_editor_tag}>".html_safe
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
      struct classes: 'disabled',
             waiting_t: :uploading_solution,
             t: :create_submission
    elsif exercise.hidden?
      struct classes: 'submission_control',
             waiting_t: :working,
             t: :continue_exercise
    elsif exercise.input_kids?
      struct classes: 'submission_control'
    else
      struct classes: 'submission_control',
             waiting_t: :sending_solution,
             t: :create_submission
    end
  end
end
