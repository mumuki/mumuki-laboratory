class CommentsController < ApplicationController
  before_action :authenticate_api!

  def index
    render json: {has_comments: has_comments?,
                  comments_count: comments_count}
  end
end
