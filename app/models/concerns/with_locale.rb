module WithLocale
  extend ActiveSupport::Concern

  included do
    scope :at_locale, lambda { where(locale: I18n.locale) }
  end
end
