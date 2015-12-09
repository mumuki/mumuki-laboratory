class Api::GuidesController < Api::BaseController
  def index
    @guides = Guide.all
    render json: { guides:
      @guides.as_json(
        only: [:id, :name, :url, :position],
        include: {
          exercises: { only: [:id, :name, :position] },
          language: { only: [:id, :name, :image_url] },
          chapter: { only: [:id], methods: [:name] }
        }
      )
    }
  end
end
