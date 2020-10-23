module PageTitleHelper
  def page_title(subject)
    name = "Mumuki#{Organization.current.title_suffix}"

    if subject && !subject.new_record?
      "#{subject.friendly} - #{name}"
    else
      "#{name}"
    end
  end
end
