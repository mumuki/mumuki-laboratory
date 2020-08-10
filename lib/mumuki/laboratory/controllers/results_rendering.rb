module Mumuki::Laboratory::Controllers::ResultsRendering
  extend ActiveSupport::Concern

  included do
    include ProgressBarHelper, ExerciseInputHelper

    before_action :set_guide_previously_done!
  end

  def render_results_json(assignment, results = {})
    if assignment.input_kids?
      merge_kids_specific_renders(assignment, results)
      layout = 'exercise_solutions/kids_results'
    else
      layout = 'exercise_solutions/results'
    end

    render json: results
                  .merge(progress_json)
                  .merge(
                    html: render_results(layout, assignment),
                    remaining_attempts_html: remaining_attempts_text(assignment),
                    current_exp: UserStats.exp_for(assignment.submitter))
  end

  def merge_kids_specific_renders(assignment, results)
    results.merge!(
        button_html: render_results_button(assignment),
        title_html: render_results_title(assignment),
        expectations: assignment.affable_expectation_results,
        tips: assignment.affable_tips,
        test_results: assignment.affable_test_results)
  end

  def progress_json
    {
      guide_finished_by_solution: guide_finished_by_solution?
    }
  end

  def render_results(results_partial, assignment)
    render_to_string partial: results_partial,
                     locals: {assignment: assignment}
  end

  def render_results_title(assignment)
    render_to_string partial: 'exercise_solutions/results_title',
                     locals: {contextualization: assignment}
  end

  def render_results_button(assignment)
    render_to_string partial: 'exercise_solutions/kids_results_button',
                     locals: {assignment: assignment}
  end

  def guide_finished_by_solution?
    !@guide_previously_done && @exercise.guide_done_for?(current_user)
  end

  def set_guide_previously_done!
    @guide_previously_done = @exercise.guide_done_for?(current_user)
  end
end
