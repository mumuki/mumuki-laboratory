module PageTitleHelper
  def page_title(subject)
    name = Organization.current.page_name

    if subject && !subject.new_record?
      "#{subject.friendly} - #{name}"
    else
      "#{name}"
    end
  end
end
