module WithResultsRendering
  extend ActiveSupport::Concern
  include ProgressBarHelper

  included do
    before_action :set_guide_previously_done
  end

  def render_json(assignment, options = {})
    render json: results_rendering_params(assignment).merge(options)
  end

  def results_rendering_params(assignment)
    {
      guide_finished_by_solution: guide_finished_by_solution?,
      class_for_progress_list_item: class_for_progress_list_item(@exercise, true),
      html: render_results(assignment)
    }
  end

  def html_rendering_params(assignment)
    {partial: 'exercise_solutions/results',
     locals: {
        assignment: assignment,
      }}
  end

  def render_results(assignment)
    render_to_string html_rendering_params(assignment)
  end

  def guide_finished_by_solution?
    !@guide_previously_done && @exercise.guide_done_for?(current_user)
  end

  def set_guide_previously_done
    @guide_previously_done = @exercise.guide_done_for?(current_user)
  end
end
