module WithResultsRendering
  extend ActiveSupport::Concern

  included do
    before_action :set_guide_previously_done
  end

  def results_rendering_params(assignment)
    {partial: 'exercise_solutions/results',
     locals: {
        assignment: assignment,
        guide_finished_by_solution: guide_finished_by_solution?
      }}
  end

  def guide_finished_by_solution?
    !@guide_previously_done && @exercise.guide_done_for?(current_user)
  end

  def set_guide_previously_done
    @guide_previously_done = @exercise.guide_done_for?(current_user)
  end
end
