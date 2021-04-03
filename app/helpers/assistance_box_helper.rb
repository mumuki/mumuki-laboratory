module AssistanceBoxHelper
  def assistance_box(assignment)
    %Q{<div class="mu-tips-box mb-3">
      #{Mumukit::Assistant::Narrator.random.compose_explanation_html assignment.tips}
    </div>}.html_safe
  end

  def should_display_assistance_box?(assignment)
    assignment.tips.present? && !assignment.solved?
  end
end
