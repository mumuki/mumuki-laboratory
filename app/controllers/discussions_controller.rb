class DiscussionsController < ApplicationController
  before_action :set_debatable

  def index
    @discussions = @debatable.discussions
  end

  def show

  end

  def create
    discussion = @debatable.create_discussion! current_user, discussion_params
    redirect_to [@debatable, discussion]
  end

  private

  def set_debatable
    @debatable_class = params[:debatable_class]
    debatable_id = params["#{@debatable_class.underscore}_id"]
    @debatable = params[:debatable_class].constantize.find(debatable_id)
  end

  def subject
    @discussion ||= Discussion.find_by(id: params[:id])
  end

  def discussion_params
    params.require(:discussion).permit(:title, :description)
  end
end
