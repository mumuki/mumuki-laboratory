class ComplementsController < GuideContainerController
  include Mumuki::Laboratory::Controllers::ValidateAccessMode

  private

  def subject
    @complement ||= Complement.find_by(id: params[:id])
  end

  def authorization_minimum_role
    :ex_student
  end

  def subject_container
    subject.guide
  end

  def contentless_subject?
    subject_container.structural_children.empty?
  end
end
