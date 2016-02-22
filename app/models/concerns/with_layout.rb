module WithLayout
  extend ActiveSupport::Concern

  included do
    enum layout: [:editor_right, :editor_bottom, :no_editor]
  end

  def playable_layout?
    [:editor_bottom, :editor_right].include? layout.to_sym
  end
end