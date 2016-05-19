class LessonsController < ComplementsController

  private

  def subject
    @lesson ||= Lesson.find_by(id: params[:id])
  end
end
