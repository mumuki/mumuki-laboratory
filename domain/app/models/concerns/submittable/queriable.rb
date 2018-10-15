module Queriable
  def submit_query!(user, attributes)
    submit! user, Query.new(attributes)
  end

  def run_query!(params)
    language.run_query!(params)
  end
end
