class Api::TopicsController < Api::BaseController

  def create
    topic = Topic.import!(params[:slug])
    render json: { topic: topic.as_json }
  end

end
