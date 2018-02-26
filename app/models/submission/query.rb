class Query < ConsoleSubmission
  attr_accessor :query, :cookie, :content

  def evaluate_exercise!(assignment)
    assignment.run_query!(content: content, query: query, cookie: cookie)
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
