module WithFeedbackRendering
  def render_feedback?(submission)
    submission.feedback.present?
  end
end
