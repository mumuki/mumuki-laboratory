class AppendixesController < ApplicationController

  def show
    @chapter = Chapter.find(params[:chapter_id])
  end

  private

  def authorization_minimum_role
    :ex_student
  end
end
