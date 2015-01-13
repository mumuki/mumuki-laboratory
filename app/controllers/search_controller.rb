class SearchController < ApplicationController
  def show
    @results = paginated Exercise.by_tag(params[:q]).order(created_at: :desc)
  end
end
