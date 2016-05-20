class ExamsController < ComplementsController

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
    redirect_to :root unless @exam.accesible_by?(current_user)
  end

end
