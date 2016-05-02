module NestedInGuide
  extend ActiveSupport::Concern
  included do
    before_action :set_lesson
  end

  def set_guide
    @guide = Guide.find(params[:guide_id])
  end

  def subject
    @guide
  end
end
