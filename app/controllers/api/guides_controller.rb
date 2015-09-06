class Api::GuidesController < Api::BaseController
  def index
    @guides = Guide.all
    render json: {users: @guides.as_json(only: [:id, :name, :language_id, :path_id, :github_repository, :position])}
  end
end
