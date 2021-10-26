class AppendixesController < ApplicationController
  def authorization_minimum_role
    :ex_student
  end

  def show
    @chapter = Chapter.find(params[:chapter_id])
  end
end
