class MessagesController < AjaxController
  before_action :set_exercise!, only: [:create, :read_messages]

  def index
    pending_messages = current_user.unread_messages
    render json: {has_messages: pending_messages.present?, messages_count: pending_messages.count}
  end

  def read_messages
    @exercise.messages_for(current_user).read_all!
    index
  end

  def create
    @exercise.submit_question! current_user, message_params
    redirect_to @exercise
  end

  def errors
    render 'messages/errors', layout: false
  end

  private

  def set_exercise!
    exercise_id = params.dig(:message, :exercise_id) || params[:exercise_id]
    @exercise = Exercise.find(exercise_id)
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
