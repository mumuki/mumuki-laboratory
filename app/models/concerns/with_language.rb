module WithLanguage
  extend ActiveSupport::Concern

  included do
    belongs_to :language
    delegate :visible_success_output?,
             :highlight_mode,
             :queriable?,
             :prompt, to: :language

    validates_presence_of :language
  end

end
