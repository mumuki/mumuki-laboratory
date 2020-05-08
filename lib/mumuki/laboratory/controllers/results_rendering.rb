module Mumuki::Laboratory::Controllers::ResultsRendering
  extend ActiveSupport::Concern

  included do
    include ProgressBarHelper, ExerciseInputHelper, ContextualizationResultHelper

    before_action :set_guide_previously_done!
  end

  def render_results_json(assignment, results = {})
    if assignment.input_kids?
      merge_kids_specific_renders(assignment, results)
      render_results = 'exercise_solutions/kids_results'
    else
      render_results = 'exercise_solutions/results'
    end

    render json: results.merge(progress_json).merge(
        html: render_results_html(render_results, assignment),
        remaining_attempts_html: remaining_attempts_text(assignment))
  end

  def merge_kids_specific_renders(assignment, results)
    results.merge!(
        button_html: render_results_button_html(assignment),
        title_html: render_results_title_html(assignment),
        expectations: humanized_expectations_results(assignment),
        tips: humanized_tips(assignment),
        test_results: humanized_test_results(assignment))
  end

  def progress_json
    {
      guide_finished_by_solution: guide_finished_by_solution?,
      class_for_progress_list_item: class_for_progress_list_item(@exercise, true)
    }
  end

  def render_results_html(results_partial, assignment)
    render_to_string partial: results_partial,
                     locals: {assignment: assignment}
  end

  def render_results_title_html(assignment)
    render_to_string partial: 'exercise_solutions/results_title',
                     locals: {contextualization: assignment}
  end

  def render_results_button_html(assignment)
    render_to_string partial: 'exercise_solutions/kids_results_button',
                     locals: {assignment: assignment}
  end

  def guide_finished_by_solution?
    !@guide_previously_done && @exercise.guide_done_for?(current_user)
  end

  def set_guide_previously_done!
    @guide_previously_done = @exercise.guide_done_for?(current_user)
  end

  def humanized_expectations_results(assignment)
    assignment.humanized_expectation_results.map { |it| humanized_expectation_result it }
  end

  def humanized_tips(assignment)
    assignment.tips.map { |it| humanized_tip it }
  end

  def humanized_test_results(assignment)
    assignment.test_results.map { |it| humanized_test_result it }
  end
end
