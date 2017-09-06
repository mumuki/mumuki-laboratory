class Content < ActiveRecord::Base
  self.abstract_class = true

  include WithDescription
  include WithLocale
  include WithSlug
  include WithUsages

  required :import_from_json!
end
