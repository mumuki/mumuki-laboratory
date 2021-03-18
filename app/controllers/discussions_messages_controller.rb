class DiscussionsMessagesController < AjaxController
  include WithUserDiscussionValidation

  before_action :set_discussion!, only: [:create, :destroy]
  before_action :authorize_user!, only: [:destroy]
  before_action :authorize_moderator!, only: [:question, :approve, :preview]

  def create
    @discussion.submit_message! message_params, current_user
    redirect_back(fallback_location: root_path)
  end

  def destroy
    current_message.destroy!
    redirect_back(fallback_location: root_path)
  end

  def preview
    render json: { preview: Message.new(content: params[:content]).content_html }
  end

  def approve
    current_message.toggle_approved! current_user
    head :ok
  end

  def question
    current_message.toggle_not_actually_a_question!
    head :ok
  end

  private

  def set_discussion!
    @discussion ||= Discussion.find_by(id: params[:discussion_id])
  end

  def authorize_user!
    current_message.authorize! current_user
  end

  def current_message
    @message ||= Message.find(params[:id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
