class MessagesController < AjaxController
  before_action :set_exercise, only: [:create, :read_messages]
  before_action :set_submission_id, only: :create

  def index
    render_messages_json
  end

  def read_messages
    @exercise.messages_for(current_user).read_all
    render_messages_json
  end

  def create
    Message.create_and_notify! message_params.merge(sender: current_user_uid, exercise: @exercise, submission_id: @submission_id, read: true)
    redirect_to @exercise
  end

  def errors
    render 'messages/errors', layout: false
  end

  private

  def render_messages_json
    render json: {has_messages: has_messages?,
                  messages_count: messages_count}
  end

  def set_exercise
    exercise_id = params[:message].present? ? params[:message][:exercise_id] : params[:exercise_id]
    @exercise = Exercise.find(exercise_id)
  end

  def set_submission_id
    @submission_id = @exercise.last_persisted_submission_id_for current_user
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
