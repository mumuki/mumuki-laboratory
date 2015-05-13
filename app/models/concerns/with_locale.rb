module WithLocale
  extend ActiveSupport::Concern

  included do
    validates_presence_of :locale
    scope :at_locale, lambda { where(locale: I18n.locale) }
  end
end
