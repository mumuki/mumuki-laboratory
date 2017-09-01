class ActiveRecord::Base
  def self.name_model_as(other)
    define_singleton_method :model_name do
      other.model_name
    end
  end

  def self.all_except(others)
    if others.present?
      where.not(id: [others.map(&:id)])
    else
      all
    end
  end

  def save(*)
    super
  rescue => e
    self.errors.add :base, e.message
    self
  end

  def save_and_notify!
    save!
    notify!
    self
  end

  def self.prepare_by(query)
    transaction do
      model = find_or_initialize_by(query)
      model.save(validate: false)
      yield model
    end
  end

  def rebuild!(associations)
    transaction do
      associations.each do |association, children|
        self.send(association).all_except(children).delete_all
        self.update! association => children
        children.each &:save!
      end
    end
    reload
  end

  def self.numbered(*associations)
    class_eval do
      associations.each do |it|
        define_method("#{it}=") do |e|
          e.merge_numbers!
          super(e)
        end
      end
    end
  end

  def self.update_or_create!(attributes)
    obj = first || new
    obj.update!(attributes)
    obj
  end

end
