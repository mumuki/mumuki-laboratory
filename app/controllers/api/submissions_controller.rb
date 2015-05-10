class Api::SubmissionsController < Api::BaseController

  def index
    @submissions = Submission.joins(:submitter).all

    @submissions = @submissions.where(exercise_id: params[:exercises]) if params[:exercises]
    @submissions = @submissions.where('users.name' => params[:users]) if params[:users]

    render json: {submissions: @submissions.map { |it|
      json = {username: it.submitter.name, content: it.content, passed: it.passed?}
      it.passed? ? json : json.merge(result: it.result)
    }}
  end

end
