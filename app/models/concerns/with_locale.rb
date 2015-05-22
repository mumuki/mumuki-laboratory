module WithLocale
  extend ActiveSupport::Concern

  included do
    validates_presence_of :locale
    scope :at_locale, lambda { |locale=I18n.locale| where(locale: locale) }
  end
end
