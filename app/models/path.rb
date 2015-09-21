class Path < ActiveRecord::Base
  include WithGuides, WithStats

  belongs_to :category
  belongs_to :language

  has_many :exercises, through: :guides

  def name

    if category.single_path?
      category.name
    else
      "#{category.name} (#{language.name})"
    end

  end
end

