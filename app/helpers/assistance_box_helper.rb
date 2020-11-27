module AssistanceBoxHelper
  def assistance_box(assignment)
    if assignment.tips.present?
      %Q{<div class="mu-tips-box">
        #{Mumukit::Assistant::Narrator.random.compose_explanation_html assignment.tips}
      </div>}.html_safe
    end
  end

  def should_display_assistance_box?(assignment)
    assignment.tips.present? && !assignment.solved?
  end
end
