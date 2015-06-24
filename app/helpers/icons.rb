module Icons
  #FIXME refactor names
  def status_icon(with_status)
    fa_icon *icon_for_status( with_status.is_a?(Symbol) ? with_status : with_status.fine_status)
  end

  def exercise_status_icon(exercise)
    link_to exercise_status_fa_icon(exercise),
            exercise_submissions_path(exercise) if current_user?
  end

  def language_icon(language, options={})
    options = {alt: language.name, height: 16, class: 'special-icon'}.merge(options)
    link_to image_tag(language.image_url, options), (options[:link_path] || guides_path(q: language.name))
  end

  private

  def exercise_status_fa_icon(exercise)
    fa_icon(*icon_for_status(exercise.status_for(current_user)))
  end

  STATUSES = {
      passed:               {class: :success, type: :check},
      passed_with_warnings: {class: :warning, type: :exclamation},
      failed:               {class: :danger,  type: :times},
      running:              {class: :info,    type: :circle},
      pending:              {class: :info,    type: 'clock-o'},
      unknown:              {class: :muted,   type: :circle},
  }.with_indifferent_access

  def status_for(s)
    STATUSES[s] || raise("Unknown status #{s}")
  end

  def class_for_status(s)
    status_for(s)[:class].to_s
  end

  def icon_type_for_status(s)
    status_for(s)[:type].to_s
  end

  def icon_for_status(s)
    status = status_for(s)
    [status[:type], class: "text-#{status[:class]} special-icon"]
  end

end
