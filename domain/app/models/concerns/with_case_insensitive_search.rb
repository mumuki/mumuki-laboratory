module WithCaseInsensitiveSearch
  extend ActiveSupport::Concern

  included do
    scope :find_by_ignore_case!, lambda { |attribute, value| where("lower(#{attribute}) = ?", value.downcase).first! }
  end
end
