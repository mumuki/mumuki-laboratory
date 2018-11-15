module WithNumber
  extend ActiveSupport::Concern

  included do
    validates_presence_of :number

    default_scope -> { order(:number) }
  end
end