class Query < Submission
  include ActiveModel::Model

  attr_accessor :query, :content

  def try_evaluate_against!(exercise)
    exercise.run_query!(content: content, query: query)
  end

  def save_results!(results, assignment)
  end
end
