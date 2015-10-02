class Query < Submission
  include ActiveModel::Model

  attr_accessor :query, :content

  def try_evaluate_against!(exercise)
    r = exercise.run_query!(content: content, query: query)
    {result: r[:result], status: Status.from_sym(r[:status])}
  end
end
