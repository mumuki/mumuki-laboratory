class ActiveRecord::Base

  def save(*)
    super
  rescue => e
    self.errors.add :base, e.message
    self
  end
end