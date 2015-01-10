class LanguagesController < ApplicationController

  before_action :set_language, only: [:show, :edit, :update, :destroy]
  before_action :authenticate!, except: [:show, :index]
  
  def index
    @languages = paginated languages
  end

  def show
  end

  def new
    @language = Language.new
  end

  def edit
  end

  def create
    @language = Language.create(language_params)
    @language.plugin_author_id = current_user.id

    if @language.save
      redirect_to @language, notice: 'Language was successfully created.'
    else
      render :new
    end
  end

  def update
    if @language.update(language_params)
      redirect_to @language, notice: 'Language was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @language.destroy
    redirect_to languages_url, notice: 'Language was successfully destroyed.'
  end
  
  private

  def set_language
    @language = Language.find(params[:id])
  end

  def language_params
    params.require(:language).permit(:name, :test_runner_url, :extension, :image_url, :plugin_author_id)
  end

  def languages
    Language.all
  end
end
