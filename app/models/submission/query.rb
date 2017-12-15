class Query < Submission
  attr_accessor :query, :cookie, :content

  def try_evaluate_exercise!(user, exercise)
    r = exercise.run_query!(user, content: content, query: query, cookie: cookie)
    {result: r[:result], status: Status.from_sym(r[:status])}
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
