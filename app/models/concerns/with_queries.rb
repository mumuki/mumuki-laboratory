module WithQueries

  def submit_query!(params)
    Query.new(params[:query], params[:content], self)
  end

end