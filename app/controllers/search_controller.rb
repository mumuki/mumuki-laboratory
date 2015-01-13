class SearchController < ApplicationController
  def show
    @results = paginated Exercise.by_tag(params[:q])
  end
end
