module WithExamsValidations

  def validate_user_in_exam(exam)
    redirect_to :root unless exam.accesible_by?(current_user)
  end


end
