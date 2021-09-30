module ExamsHelper
  def exam_information_for(user, exam)
    %Q{
      #{course_information_for(user, exam)}
      #{date_information_for(exam)}
      #{duration_information_for(exam)}
    }.html_safe
  end

  private

  def course_information_for(user, exam)
    if user.teacher_here?
      "#{fa_icon('graduation-cap', class: 'fa-fw',
                 text: "<strong>#{t :course}:</strong> #{exam.course.canonical_code}".html_safe)}
      <br>"
    end
  end

  def date_information_for(exam)
    "#{fa_icon('calendar-alt', class: 'fa-fw',
               text: "<strong>#{t :date_and_time}:</strong> #{local_time_without_time_zone(exam.start_time)} - #{local_time(exam.end_time)}".html_safe)}
    <br>"
  end

  def duration_information_for(exam)
    if exam.duration?
      "#{fa_icon(:stopwatch, class: 'fa-fw',
                 text: "<strong>#{t :available_time}:</strong> #{t :time_in_minutes, time: exam.duration}".html_safe)}
      <br>"
    end
  end
end
