class SearchController < ApplicationController
  def show
    @q = Exercise.ransack(params[:q])
    @results = paginated @q.result(distinct: true)
  end
end
