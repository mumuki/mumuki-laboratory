class Query
  attr_accessor :query, :content, :exercise, :status, :result

  def initialize(query, content, exercise)
    @query = query
    @content = content
    @exercise = exercise
  end

  def run!
    response = exercise.run_query!(content: content, query: query)
    @result = response[:result]
    @status = Status.from_sym response[:status]
  end
end
