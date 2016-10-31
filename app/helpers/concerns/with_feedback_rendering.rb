module WithFeedbackRendering
  def render_feedback?(assignment)
    StatusRenderingVerbosity.render_feedback?(assignment.feedback)
  end
end
