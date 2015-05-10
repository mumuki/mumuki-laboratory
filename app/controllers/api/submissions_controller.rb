class Api::SubmissionsController < Api::BaseController

  def index
    Submission.all.as_json(only: [:content])
    render json: {submissions: []}
  end

end
