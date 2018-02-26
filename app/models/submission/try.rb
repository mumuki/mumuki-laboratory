class Try < Submission
  attr_accessor :query, :cookie

  def try_evaluate_exercise!(assignment)
    format_result assignment.run_try!(query: query, cookie: cookie).except(:response_type)
  end

  def save_submission!(assignment)
    assignment.query_results = [] if cookie.blank?
    assignment.queries = cookie.insert_last(query)
    assignment.save!
  end

  def save_results!(results, assignment)
    changes = { status: results[:status], result: results[:result] }
    changes.merge! query_results: assignment.query_results.insert_last(results[:query_result]) if results[:query_result]

    assignment.update! changes
  end
end
