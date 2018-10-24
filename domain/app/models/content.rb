class Content < ApplicationRecord
  self.abstract_class = true

  include WithDescription
  include WithLocale
  include WithSlug
  include WithUsages
  include WithName

  def to_resource_h
    as_json(only: [:name, :slug, :description, :locale]).symbolize_keys
  end

end

