class LessonsController < GuideContainerController
  include Mumuki::Laboratory::Controllers::ImmersiveNavigation

  private

  def subject
    @lesson ||= Lesson.find_by(id: params[:id])
  end
end
