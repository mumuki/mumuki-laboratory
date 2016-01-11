class Api::GuidesController < Api::BaseController

  def index
    @guides = Guide.all
    render json: { guides:
      @guides.as_json(
        only: [:id, :name, :slug, :position],
        include: {
          exercises: { only: [:id, :name, :position] },
          language: { only: [:id, :name] },
          chapter: { only: [:id], methods: [:name] }
        }
      )
    }
  end

  def create
    guide = Guide.find_or_create_by(slug: params[:slug])
    guide.import_from_json!(guide_params)
    render json: { guide: guide.as_json }
  end

  private

  def guide_params
    params.permit(:slug,
                  :beta,
                  :type,
                  :name,
                  :description,
                  :corollary,
                  :locale,
                  :language,
                  :id_format,
                  expectations: [:binding, :inspection ],
                  exercises: [
                    :type,
                    :tag_list,
                    :layout,
                    :name,
                    :description,
                    :hint,
                    :corollary,
                    :test,
                    :id,
                    :extra,
                    expectations: [ :binding, :inspection ]
                  ])
  end

end
