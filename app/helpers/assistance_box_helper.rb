module AssistanceBoxHelper
  def assistance_box(assignment)
    if assignment.tips.present?
      %Q{<div class="mu-tips-box">
        #{Mumukit::Assistant::Narrator.random.compose_explanation_html assignment.tips}
      </div>}.html_safe
    end
  end

  def assistance_rules_passed?(assignment)
    Mumukit::Assistant. parse(assignment.exercise.assistance_rules).rules.any? { |rule| rule.matches? assignment }
  end
end
