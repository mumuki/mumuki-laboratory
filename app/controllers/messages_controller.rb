class MessagesController < AjaxController
  before_action :set_exercise, only: [:create, :read_messages]
  before_action :set_assignment, only: :create

  def index
    render json: {has_messages: has_messages?, messages_count: messages_count}
  end

  def read_messages
    @exercise.messages_for(current_user).read_all!
    index
  end

  def create
    Message.create_and_notify! message_params
                                 .merge(sender: current_user_uid, exercise: @exercise,
                                        submission_id: @assignment.submission_id, read: true)
    redirect_to @exercise
  end

  def errors
    render 'messages/errors', layout: false
  end

  private

  def set_exercise
    exercise_id = params.dig(:message, :exercise_id)  || params[:exercise_id]
    @exercise = Exercise.find(exercise_id)
  end

  def set_assignment
    @assignment = @exercise.find_or_create_assignment_for current_user
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
