class ExamsController < ContentController
  before_action :validate_accessible!, only: :show

  private

  def subject
    @exam = Exam.find_by(classroom_id: params[:id]) || Exam.find_by(id: params[:id])
  end

  def accessible_subject
    subject
  end

end
