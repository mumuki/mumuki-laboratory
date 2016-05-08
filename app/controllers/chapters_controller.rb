require 'addressable/uri'

class ChaptersController < ApplicationController
  def show
    @chapter = Chapter.find(params[:id])
  end

  def subject
    @chapter
  end
end
