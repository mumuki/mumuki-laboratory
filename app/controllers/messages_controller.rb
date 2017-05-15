class MessagesController < AjaxController
  before_action :set_exercise, only: :create

  def index
    render json: {has_messages: has_messages?,
                  messages_count: messages_count}
  end

  def create
    Message.create_and_notify! message_params.merge(sender: current_user_uid, exercise: @exercise, submission_id: @submission_id, read: true)
    redirect_to @exercise
  end

  def errors
    render 'messages/errors', layout: false
  end

  private

  def set_exercise
    @exercise = Exercise.find(params[:message][:exercise_id])
    @submission_id = @exercise.last_persisted_submission_id_for current_user
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
