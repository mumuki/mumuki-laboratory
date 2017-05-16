class Query < Submission
  include ActiveModel::Model

  attr_accessor :query, :cookie, :content

  def try_evaluate_against!(exercise)
    r = exercise.run_query!(content: content, query: query, cookie: cookie)
    {result: r[:result], status: Status.from_sym(r[:status])}
  end


  def setup_assignment!(assignment)
    assignment.exercise.setup_query_assignment!(assignment)
    super
  end

  def save_results!(_results, assignment)
    assignment.exercise.save_query_results!(assignment)
  end

  def notify_results!(_results, assignment)
  end
end
