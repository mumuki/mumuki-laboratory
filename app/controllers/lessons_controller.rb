class LessonsController < GuideContainerController

  private

  def subject
    @lesson ||= Lesson.find_by(id: params[:id])
  end
end
