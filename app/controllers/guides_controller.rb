class GuidesController < ApplicationController

  before_action :authenticate!, except: [:index, :show]
  before_action :set_guide, only: [:show, :solutions_dump]

  def new
    @guide = Guide.new(name: params[:q])
  end

  def create
    @guide = Guide.new(guide_params.merge(author: current_user))
    if @guide.save
      @guide.import!
      redirect_to guide_path(@guide), notice: t(:guide_created)
    else
      render :new
    end
  end

  def show
    if current_user?
      @stats = @guide.stats_for(current_user)
      @next_exercise = @guide.next_exercise(current_user)
    else
      @next_exercise = @guide.first_exercise
    end
  end

  def index
    @q = params[:q]
    @guides = paginated Guide.by_full_text(@q)
  end

  def solutions_dump
    @assignments = @guide.solutions_for(current_user)

    stream = render_to_string layout: false, formats: [:text]
    send_data(stream, type: 'text/plain', filename: "guide.#{@guide.language.extension}")
  end

  private

  def subject
    @guide
  end


  def set_guide
    @guide = Guide.find(params[:id])
  end

  def guide_params
    params.require(:guide).permit(:url)
  end
end
