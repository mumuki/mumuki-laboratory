class Api::GuidesController < Api::BaseController

  def create
    guide = Guide.find_or_create_by(slug: params[:slug])
    guide.import!
    render json: { guide: guide.as_json }
  end

end
