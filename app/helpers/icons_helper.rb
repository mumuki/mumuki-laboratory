module IconsHelper
  def status_icon(status_like)
    fa_icon *icon_for(status_like.to_submission_status)
  end

  def fixed_fa_icon(name, options={})
    fa_icon name, options.merge(class: 'fa-fw fixed-icon')
  end

  def exercise_status_icon(exercise)
    link_to exercise_status_fa_icon(exercise),
            exercise_path(exercise) if current_user?
  end

  def language_icon(language)
    tag('span', class: "fa da da-#{language.devicon} lang-icon", alt: language.name)
  end

  private

  def contextualization_fa_icon(contextualization)
    fa_icon(*icon_for(contextualization))
  end

  def exercise_status_fa_icon(exercise)
    contextualization_fa_icon(exercise.assignment_for(current_user))
  end

  def discussion_status_fa_icon(discussion)
    contextualization_fa_icon(discussion)
  end

  def icon_for(iconizable)
    iconized = iconizable.iconize
    [iconized[:type], class: "text-#{iconized[:class]} status-icon"]
  end

  def class_for_exercise(exercise)
    icon_class_for(exercise.assignment_for(current_user))
  end

  def icon_class_for(iconizable)
    iconizable.iconize[:class].to_s
  end

  def icon_type_for(iconizable)
    iconizable.iconize[:type].to_s
  end

  def label_for_contextualization(contextualization)
    iconized = contextualization.iconize
    %Q{
      <span class="text-#{iconized[:class]} status-label">
        #{fa_icon "#{iconized[:type]}"}
        <span>#{t contextualization.visible_status}</span>
      </span>
    }.html_safe
  end

  def icon_for_read(read)
    tag('i', class: "fa fa-envelope#{read ? '-o' : ''}")
  end
end
