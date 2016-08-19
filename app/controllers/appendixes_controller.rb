class AppendixesController < ApplicationController
  def show
    @chapter = Chapter.find(params[:chapter_id])
  end
end
