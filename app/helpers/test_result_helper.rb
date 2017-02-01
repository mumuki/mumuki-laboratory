module TestResultHelper
  def render_test_results(assignment)
    if assignment.test_results.present?
      render partial: 'layouts/test_results', locals: {
          visible_success_output: assignment.visible_success_output?,
          test_results: assignment.test_results,
          output_content_type: assignment.output_content_type}
    else
      assignment.result_html
    end
  end
end
