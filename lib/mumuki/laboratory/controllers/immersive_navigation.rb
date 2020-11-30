module Mumuki::Laboratory::Controllers::ImmersiveNavigation
  extend ActiveSupport::Concern

  def immersive_subject
    subject.navigable_content_in(current_immersive_context)
  end
end
