class GuidesController < ApplicationController

  before_action :authenticate!, except: [:index, :show]
  before_action :set_guide, only: [:show, :edit, :details, :update]

  def new
    @guide = Guide.new
  end

  def update
    if @guide.update(guide_params)
      redirect_to update, notice: 'Guide was successfully updated.'
    else
      render :edit
    end
  end

  def create
    @guide = Guide.new(guide_params.merge(author: current_user))
    @guide.imports.build
    if @guide.save
      @guide.register_post_commit_hook!(guide_imports_url(@guide))
      redirect_to @guide, notice: t(:guide_created)
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

  private

  def set_guide
    @guide = Guide.find(params[:id])
  end

  def guide_params
    params.require(:guide).permit(:github_repository, :name, :description)
  end
end
