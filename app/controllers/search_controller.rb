class SearchController < ApplicationController
  def show
    @results = paginated Exercise.by_full_text(params[:q]).order(submissions_count: :desc)
  end
end
