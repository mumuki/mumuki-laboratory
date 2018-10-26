module WithName
  extend ActiveSupport::Concern

  included do
    validates_presence_of :name
    validate :ensure_name_format
  end

  private

  def ensure_name_format
    errors.add :name, :invalid_format if name&.include?('/')
  end

end
