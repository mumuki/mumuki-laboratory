class Api::GuidesController < Api::BaseController
  def index
    @guides = Guide.all
    render json: {guides: @guides.as_json(only: [:id, :name, :language_id, :path_id, :github_repository, :position],
                    include: {exercises: {only: [:id, :name, :position]}})}
  end
end
