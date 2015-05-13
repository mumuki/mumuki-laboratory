class GuidesController < ApplicationController

  before_action :authenticate!, except: [:index, :show]
  before_action :set_guide, only: [:show, :edit, :details, :update, :collaborators_refresh]

  def new
    @guide = Guide.new(name: params[:q])
  end

  def update
    if @guide.update(guide_params)
      redirect_to edit_guide_path(@guide), notice: 'Guide was successfully updated.'
    else
      render :edit
    end
  end

  def create
    @guide = Guide.new(guide_params.merge(author: current_user))
    if @guide.save
      begin
        current_user.ensure_repo_exists! @guide
        current_user.register_post_commit_hook!(@guide, guide_imports_url(@guide))
        redirect_to edit_guide_path(@guide), notice: t(:guide_created)
      rescue
        redirect_to edit_guide_path(@guide), alert: t(:no_permissions)
      end
    else
      render :new
    end
  end

  def show
    if current_user?
      @stats = @guide.stats(current_user)
      @next_exercise = @guide.next_exercise(current_user)
    end
  end

  def details
  end

  def index
    @q = params[:q]
    @guides = paginated Guide.by_full_text(@q).at_locale
  end

  def collaborators_refresh
    #FIXME should be done in a job
    @guide.update_collaborators!
    redirect_to edit_guide_path(@guide), notice: t(:collaborators_refreshed)
  end

  private

  def set_guide
    @guide = Guide.find(params[:id])
  end

  def guide_params
    params.require(:guide).permit(:github_repository, :name, :description, :locale, :original_id_format, :language_id, suggested_guide_ids: [])
  end
end
