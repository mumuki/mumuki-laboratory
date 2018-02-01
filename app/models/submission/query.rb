class Query < Submission
  attr_accessor :query, :cookie, :content

  def try_evaluate_exercise!(assignment)
    r = assignment.run_query!(content: content, query: query, cookie: cookie)
    {result: r[:result], status: r[:status].to_mumuki_status}
  end


  def save_submission!(assignment)
    assignment.exercise.setup_query_assignment!(assignment)
    super
  end

  def save_results!(_results, assignment)
    assignment.exercise.save_query_results!(assignment)
  end

  def notify_results!(*)
  end
end
