class ChaptersController < ApplicationController
  def show
    @chapter = Chapter.find(params[:id])
  end

  def index
    @chapters = Chapter.all
  end

  def subject
    @chapter
  end
end
