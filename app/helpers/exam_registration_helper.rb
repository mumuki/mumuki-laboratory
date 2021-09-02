module ExamRegistrationHelper
  def exam_registration_view
    if @registration.ended?
      { icon: :times_circle, class: :danger, t: :exam_registration_finished_html }
    else
      { icon: :info_circle, class: :info, t: :exam_registration_explanation_html }
    end
  end
end
