module ContextualizationResultHelper
  def humanized_expectation_result_item(expectation_result)
    %Q{<li>#{status_icon(expectation_result[:result])} #{humanized_expectation_explanation expectation_result}</li>}.html_safe
  end

  def humanized_expectation_explanation(expectation_result)
    sanitized Mumukit::ContentType::Markdown.to_html(expectation_result[:explanation], one_liner: true)
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
      contextualization.solved? ? :correct_answer : :wrong_answer
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
