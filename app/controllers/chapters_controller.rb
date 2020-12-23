require 'addressable/uri'

# It acts as a guide container in monolesson contexts
class ChaptersController < GuideContainerController
  include Mumuki::Laboratory::Controllers::ImmersiveNavigation

  def subject
    @chapter ||= Chapter.find_by(id: params[:id])
  end

  private

  def set_guide
    @monolesson = subject.monolesson
    @guide = @monolesson&.guide
  end
end
