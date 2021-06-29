module ExamRegistrationHelper
  def exam_registration_view
    if @registration.end_time.past?
      { icon: :times_circle, class: :danger, t: :exam_registration_finished_html }
    else
      { icon: :info_circle, class: :info, t: :exam_registration_explanation_html }
    end
  end

  def current_time_zone_html
    %Q{(<span class="select-date-timezone">#{Organization.current.time_zone}</span>)}.html_safe
  end
end
