module ContextualizationResultHelper
  def t_expectation(expectation)
    raw Mumukit::Inspection::Expectation.parse(expectation).translate
  end

  def humanized_expectation_result_item(expectation)
    %Q{<li>#{status_icon(expectation[:result])} #{t_expectation expectation}</li>}.html_safe
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
    elsif contextualization.exercise.choices?
      contextualization.passed? ? :correct_answer : :wrong_answer
    else
      contextualization.submission_status
    end
  end

  def render_test_results(contextualization)
    if contextualization.test_results.present?
      render partial: 'layouts/test_results', locals: { contextualization: contextualization}
    else
      render partial: 'layouts/result', locals: { contextualization: contextualization }
    end
  end
end
