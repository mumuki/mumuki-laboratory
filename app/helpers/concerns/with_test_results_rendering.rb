module WithTestResultsRendering
  def render_test_results(assignment)
    if assignment.test_results.present?
      render partial: 'layouts/test_results', locals: {test_results: assignment.test_results, output_content_type: assignment.output_content_type}
    else
      assignment.result_html
    end
  end
end
