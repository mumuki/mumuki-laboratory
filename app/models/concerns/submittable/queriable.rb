module Queriable
  def submit_query!(user, attributes)
    submit! user, Query.new(attributes)
  end
end
