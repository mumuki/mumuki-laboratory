class Api::SubmissionsController < Api::BaseController

  def index
    render json: {submissions: []}
  end

end
