module ContextualizationResultHelper
  def humanized_expectation_result_item(expectation_result)
    %Q{<li>#{status_icon(expectation_result[:result])} #{sanitized expectation_result[:explanation]}</li>}.html_safe
  end

  def render_feedback?(contextualization)
    contextualization.feedback.present?
  end

  def t_contextualization_status(contextualization)
    t contextualization_status contextualization
  end

  def contextualization_status(contextualization)
    if contextualization.exercise.hidden?
      :hidden_done
    elsif contextualization.exercise.choice?
      contextualization.passed? ? :correct_answer : :wrong_answer
    else
      contextualization.submission_status
    end
  end

  def render_test_results(contextualization)
    if contextualization.test_results.present?
      template = contextualization.result.present? ? 'layouts/mixed_results' : 'layouts/test_results'
      render partial: template, locals: { contextualization: contextualization }
    else
      render partial: 'layouts/result', locals: { contextualization: contextualization }
    end
  end
end
