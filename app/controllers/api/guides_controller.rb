class Api::GuidesController < Api::BaseController

  def create
    guide = Guide.find_or_create_by(slug: params[:slug])
    guide.import!
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
                    :extra_visible,
                    :default_content,
                    expectations: [ :binding, :inspection ]
                  ])
  end

end
