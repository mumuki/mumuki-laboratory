module WithFeedbackRendering
  def render_feedback?(submission)
    Rails.configuration.verbosity.render_feedback?(submission.feedback)
  end
end
