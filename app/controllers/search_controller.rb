class SearchController < ApplicationController
  def show
    @q = params[:q]
    @results = paginated Exercise.by_full_text(@q).reorder(submissions_count: :desc)
  end
end
