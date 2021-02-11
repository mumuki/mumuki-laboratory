module ProgressBarHelper
  include IconsHelper

  def class_for_progress_list_item(assignment, active)
    "progress-list-item text-center #{icon_class_for(assignment)} #{active ? 'active' : ''}"
  end

end
