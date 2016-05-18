class ExamsController < ComplementsController


  private

  def subject
    @exam
  end

  def set_item
    @exam = Exam.find_by(id: params[:id])
    @guide = @exam.guide
  end

end
