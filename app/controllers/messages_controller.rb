class MessagesController < AjaxController
  before_action :set_exercise, only: :create

  def index
    render json: {has_messages: has_messages?,
                  messages_count: messages_count}
  end

  def create
    Message.create_and_notify! message_params.merge(sender: current_user_uid, exercise: @exercise, read: true)
    redirect_to @exercise
  end

  def errors
    render 'messages/errors', layout: false
  end

  private

  def set_exercise
    @exercise = Assignment.find_by(submission_id: params[:message][:submission_id]).exercise
  end

  def message_params
    params.require(:message).permit(:content, :submission_id)
  end
end
