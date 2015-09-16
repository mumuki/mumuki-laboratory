class Api::GuidesController < Api::BaseController
  def index
    @guides = Guide.all
    render json: { guides:
      @guides.as_json(
        only: [:id, :name, :github_repository, :position],
        include: {
          exercises: { only: [:id, :name, :position] },
          language: { only: [:id, :name] },
          path: { only: [:id], methods: [:name] }
        }
      )
    }
  end
end
