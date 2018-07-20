require 'addressable/uri'

class ChaptersController < ContentController
  def show
  end

  def subject
    @chapter ||= Chapter.find_by(id: params[:id])
  end
end
