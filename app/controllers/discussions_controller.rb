class DiscussionsController < ApplicationController
  include Mumuki::Laboratory::Controllers::Content
  include WithUserDiscussionValidation

  before_action :set_debatable, except: [:subscription]
  before_action :authenticate!, only: [:update, :create]
  before_action :discussion_filter_params, only: :index
  before_action :read_discussion, only: :show
  before_action :authorize_moderator!, only: [:responsible]

  helper_method :discussion_filter_params

  def index
    @discussions = current_content_discussions.for_user(current_user)
    @filtered_discussions = @discussions.scoped_query_by(discussion_filter_params)
  end

  def new
    @discussion = @debatable.new_discussion_for current_user
  end

  def show
  end

  def update
    subject.update_status! params[:status], current_user
    redirect_to [@debatable, subject], notice: I18n.t(:discussion_updated)
  end

  def subscription
    current_user&.toggle_subscription!(subject)
    head :ok
  end

  def upvote
    current_user&.toggle_upvote!(subject)
    head :ok
  end

  def responsible
    if subject.can_toggle_responsible? current_user
      subject.toggle_responsible! current_user

      subject.any_responsible? ?
        flash.now.notice = I18n.t(:you_will_reply_notice) : flash.now.notice = I18n.t(:you_wont_reply_notice)

      status = :ok
    else
      subject.any_responsible? ?
        flash.now.alert = I18n.t(:someone_else_will_reply) : flash.now.alert = I18n.t(:reply_not_required)

      status = :conflict
    end

    render :partial => 'layouts/toast', status: status
  end

  def create
    discussion = @debatable.discuss! current_user, discussion_params
    redirect_to [@debatable, discussion]
  end

  private

  def default_immersive_path_for(context)
    context.forum_enabled? ? discussions_path : root_path
  end

  def current_content_discussions
    @debatable.discussions_in_organization
  end

  def set_debatable
    @debatable_class = params[:debatable_class]
    @debatable = Discussion.debatable_for(@debatable_class, params)
  end

  def subject
    @discussion ||= Discussion.find_by(id: params[:id])
  end

  def read_discussion
    @discussion.subscription_for(current_user)&.read!
  end

  def discussion_params
    params.require(:discussion).permit(:title, :description)
  end

  def discussion_filter_params
    @filter_params ||= params.permit(Discussion.permitted_query_params)
  end
end
