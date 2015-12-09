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

  def create
    guide = Guide.find_or_create_by(slug: params[:slug])
    guide.read_from_json(guide_params)
    render json: { guide: guide.as_json }
  end

  private

  def guide_params
    params.permit(:url, :beta, :learning, :name, :description, :corollary, :locale, :expectations, :language,
      exercises: [:type, :tag_list, :layout, :name, :description, :hint, :corollary, :test, :expectations, :original_id])
  end

end
