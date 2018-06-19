class DiscussionsController < AjaxController
  before_action :set_debatable
  before_action :authenticate!, only: [:update, :create]
  before_action :discussion_filter_params, only: [:index]

  def index
    @discussions = @debatable.discussions.for_user(current_user).search_by(params)
  end

  def show

  end

  def update
    subject.update_status! params[:status], current_user
    redirect_to [@debatable, subject], notice: I18n.t(:discussion_updated)
  end

  def subscription
    current_user&.toggle_subscription(subject)
    head :ok
  end

  def create
    discussion = @debatable.create_discussion! current_user, discussion_create_params
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

  def discussion_create_params
    params.require(:discussion).permit(:title, :description)
  end

  def discussion_filter_params
    @filter_params = params.permit(Discussion.permitted_filtering_params)
  end
end
