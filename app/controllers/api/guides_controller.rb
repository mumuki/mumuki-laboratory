class Api::GuidesController < Api::BaseController
  def index
    @guides = Guide.all
    render json: { guides:
      @guides.as_json(
        only: [:id, :name, :path_id, :github_repository, :position],
        include: {
          exercises: { only: [:id, :name, :position] },
          language: { only: [:id, :name] }
        }
      )
    }
  end
end
