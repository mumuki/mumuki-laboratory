class Api::GuidesController < Api::BaseController

  def create
    guide = Guide.import!(params[:slug])
    render json: { guide: guide.as_json }
  end

end
