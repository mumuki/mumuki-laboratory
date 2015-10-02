module WithQueries

  def submit_query!(params)
    Query.new(query: params[:query], content: params[:content], exercise: self)
  end

end
