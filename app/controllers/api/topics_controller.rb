class Api::TopicsController < Api::BaseController

  def create
    topic = Topic.find_or_create_by(slug: params[:slug])
    topic.import!
    render json: { topic: topic.as_json }
  end

end
