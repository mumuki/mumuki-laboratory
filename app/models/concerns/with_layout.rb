module WithLayout
  extend ActiveSupport::Concern

  included do
    enum layout: [:input_right, :input_bottom, :no_input]
  end

  def playable_layout?
    layout.to_sym != :no_input
  end
end
