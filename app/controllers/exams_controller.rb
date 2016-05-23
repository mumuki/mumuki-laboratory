class ExamsController < GuideContainerController
  include WithExamsValidations

  before_action :validate_user, only: :show

  private

  def subject
    @exam = Exam.find_by(classroom_id: params[:id]) || Exam.find_by(id: params[:id])
  end

  def validate_user
    validate_accessible @exam
  end

end
