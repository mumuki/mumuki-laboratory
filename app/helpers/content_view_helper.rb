module ContentViewHelper
  def full_title_for(content)
    "#{t(:chapter_number, number: content.number)}: #{content.name}"
  end

  def short_title_for(content)
    content.name
  end
end
