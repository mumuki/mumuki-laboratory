class ChaptersController < ApplicationController
  before_action :authenticate!, only: :show

  def show
    @chapter = Chapter.find(params[:id])
  end

  def index
    @chapters = Chapter.all.order(:number)
  end

  def subject
    @chapter
  end
end
