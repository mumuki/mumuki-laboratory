class SearchController < ApplicationController
  def show
    @q = params[:q]
    @results = paginated Exercise.by_full_text(@q).order(submissions_count: :desc)
  end
end
