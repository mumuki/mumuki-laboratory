require 'addressable/uri'

# It acts as a guide container in mono_lesson contexts
class ChaptersController < GuideContainerController
  include Mumuki::Laboratory::Controllers::ImmersiveNavigation

  def subject
    @chapter ||= Chapter.find_by(id: params[:id])
  end

  private

  def set_guide
    @mono_lesson = subject.mono_lesson
    @guide = @mono_lesson&.guide
  end
end
