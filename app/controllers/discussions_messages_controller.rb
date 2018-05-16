class DiscussionsMessagesController < AjaxController
  before_action :set_discussion!, only: [:create]

  def create
    @discussion.submit_message! message_params, current_user
    redirect_back(fallback_location: root_path)
  end

  private

  def set_discussion!
    @discussion ||= Discussion.find_by(id: params[:discussion_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
