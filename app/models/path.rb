class Path < ActiveRecord::Base
  include WithGuides

  belongs_to :category
  belongs_to :language

  def name
    if category.single_path?
      category.name
    else
      "#{category.name} (#{language.name})"
    end
  end
end
