require 'addressable/uri'

class ChaptersController < ApplicationController
  include Mumuki::Laboratory::Controllers::Content
  include Mumuki::Laboratory::Controllers::ImmersiveNavigation

  def show
  end

  def subject
    @chapter ||= Chapter.find_by(id: params[:id])
  end
end
