class Query
  include ActiveModel::Model

  attr_accessor :query, :content, :exercise, :status, :result

  def run!
    response = exercise.run_query!(content: content, query: query)
    @result = response[:result]
    @status = Status.from_sym response[:status]
  end
end
