module Queriable
  def submit_query!(user, attributes)
    submit! user, Query.new(attributes)
  end

  def run_query!(user, params)
    language.run_query!(params.merge(extra: extra_for(user)))
  end
end
