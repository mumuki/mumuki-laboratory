module ContextualizationResultHelper
  def render_affable_expectation_result(affable_expectation_result)
    %Q{#{status_icon(affable_expectation_result[:result])} #{affable_expectation_result[:explanation]}}.html_safe
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

  def render_test_result_header(test_result)
    title = test_result[:title]
    summary = test_result[:summary]

    if title.present?
      %Q{<strong class="example-title">#{title}</strong>#{summary&.prepend(': ')}}.html_safe
    elsif summary
      %Q{<strong class="example-title">#{summary}</strong>}.html_safe
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
