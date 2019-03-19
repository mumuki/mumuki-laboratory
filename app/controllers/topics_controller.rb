class TopicsController < ApplicationController
  def show_transparently
    redirect_to_usage Topic.find_transparently!(params)
  end
end
