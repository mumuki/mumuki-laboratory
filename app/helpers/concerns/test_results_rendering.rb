module TestResultsRendering
  def render_test_results(submission)
    if submission.test_results.present?
      render partial: 'layouts/test_results', locals: {test_results: submission.test_results}
    else
      submission.result_html
    end
  end
end
