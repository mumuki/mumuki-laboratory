require 'addressable/uri'

class ChaptersController < ApplicationController
  before_action :redirect_to_last_guide_if_possible, only: :index

  def show
    @chapter = Chapter.find(params[:id])
  end

  def index
    @chapters = Chapter.all
  end

  def subject
    @chapter
  end

  private

  def redirect_to_last_guide_if_possible
    redirect_to_last_guide if should_redirect?
  end

  def should_redirect?
    visitor_recurrent? && visitor_comes_from_internet?
  end

end
