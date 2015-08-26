module WithTestResultsRendering
  def render_test_results(solution)
    if solution.test_results.present?
      render partial: 'layouts/test_results', locals: {test_results: solution.test_results, output_content_type: solution.output_content_type}
    else
      solution.result_html
    end
  end
end
