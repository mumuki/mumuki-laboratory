class MessagesController < AjaxController
  def index
    render json: {has_messages: has_messages?,
                  messages_count: messages_count}
  end
end
