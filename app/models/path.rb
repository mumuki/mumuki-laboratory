class Path < ActiveRecord::Base
  include WithGuides

  belongs_to :category
  belongs_to :language

  def to_s
    "#{language.name}/#{category.name}"
  end
end
