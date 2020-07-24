class DiscussionsController < ApplicationController
  include Mumuki::Laboratory::Controllers::Content

  # discussions are not enabled for all organitions nor all users
  # there is no need to validate forum existance when creating; next validation is stronger
  before_action :validate_forum_enabled!, except: :create
  before_action :validate_can_create_discusssion!, only: :create

  # users are not allowed to access discussions during exams
  before_action :validate_not_in_exam!

  before_action :set_debatable, except: [:subscription]
  before_action :authenticate!, only: [:update, :create]
  before_action :discussion_filter_params, only: :index
  before_action :read_discussion, only: :show

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

  def create
    discussion = @debatable.discuss! current_user, discussion_params
    redirect_to [@debatable, discussion]
  end

  private

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

  def validate_forum_enabled!
    raise Mumuki::Domain::NotFoundError unless Organization.current.forum_enabled?
  end

  def validate_can_create_discusssion!
    raise Mumuki::Domain::NotFoundError unless Organization.current.can_create_discussions?(current_user)
  end

  def validate_not_in_exam!
    raise Mumuki::Domain::BlockedForumError if current_user&.currently_in_exam?
  end
end
