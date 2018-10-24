module WithName
  extend ActiveSupport::Concern

  included do
    validate :ensure_name_format
  end

  private

  def ensure_name_format
    errors.add :base, :invalid_name_format if name.include?('/')
  end

end
