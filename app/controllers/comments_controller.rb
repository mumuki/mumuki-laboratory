class CommentsController < AjaxController
  def index
    render json: {has_comments: has_comments?,
                  comments_count: comments_count}
  end
end
