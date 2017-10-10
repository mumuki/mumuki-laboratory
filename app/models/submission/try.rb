class Try < PersistentSubmission
  attr_accessor :query, :cookie

  def try_evaluate_exercise!(exercise)
    exercise.run_try!(query: query, cookie: cookie).except(:response_type)
  end

  def save_submission!(assignment)
    assignment.query_results = [] if cookie.blank?
    assignment.queries = cookie.insert_last(query)
    assignment.save!
  end

  def save_results!(results, assignment)
    assignment.update! status: results[:status],
                       result: results[:result],
                       query_results: assignment.query_results.insert_last(results[:query_result])
  end
end
