module WithLocale
  extend ActiveSupport::Concern

  included do
    validates_presence_of :locale
  end
end
