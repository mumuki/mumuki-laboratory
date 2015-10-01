module WithFeedbackRendering
  def render_feedback?(assignment)
    Rails.configuration.verbosity.render_feedback?(assignment.feedback)
  end
end
