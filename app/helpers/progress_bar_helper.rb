module ProgressBarHelper
  def class_for_progress_list_item(exercise, active)
    "progress-list-item text-center #{class_for_exercise(exercise)} #{active ? 'active' : ''}"
  end

end
