class Path < ActiveRecord::Base
  include WithPathRules, WithStats

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

  def friendly
    name
  end

  def rebuild!(guides)
    transaction do
      path_rules.delete_all
      path_rules = guides.each_with_index.map do |it, index|
        it.positionate! self, index+1
      end
      update path_rules: path_rules
    end
  end
end

