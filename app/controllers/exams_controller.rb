class ExamsController < ComplementsController
  include WithExamsValidations

  before_action :validate_user, only: :show

  private

  def subject
    @exam
  end

  def set_item
    @exam = Exam.find_by(classroom_id: params[:id]) || Exam.find_by(id: params[:id])
    @guide = @exam.guide
  end

  def validate_user
    validate_user_in_exam @exam
  end

end
