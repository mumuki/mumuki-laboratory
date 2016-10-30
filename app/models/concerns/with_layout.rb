module WithLayout
  extend ActiveSupport::Concern

  included do
    enum layout: [:input_right, :input_bottom]
  end
end
