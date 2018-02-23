class Query < Submission
  include ConsoleSubmission
  attr_accessor :query, :cookie, :content

  def try_evaluate_exercise!(assignment)
    format_result assignment.run_query!(content: content, query: query, cookie: cookie)
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
