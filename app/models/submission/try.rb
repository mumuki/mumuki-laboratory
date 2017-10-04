class Try < PersistentSubmission
  attr_accessor :query, :cookie

  def try_evaluate_against!(exercise)
    exercise.run_try!(query: content, cookie: cookie).except(:response_type)
  end

  def save_submission!(assignment)
    assignment.queries = [query] + cookie
    assignment.save!
  end

  def save_results!(results, assignment)
    assignment.update! results
  end
end
