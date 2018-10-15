class Content < ApplicationRecord
  self.abstract_class = true

  include WithDescription
  include WithLocale
  include WithSlug
  include WithUsages

end

