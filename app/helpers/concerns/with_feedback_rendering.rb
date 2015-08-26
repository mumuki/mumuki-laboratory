module WithFeedbackRendering
  def render_feedback?(solution)
    Rails.configuration.verbosity.render_feedback?(solution.feedback)
  end
end
