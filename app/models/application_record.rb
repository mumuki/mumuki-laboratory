class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.defaults(&block)
    after_initialize :defaults, if: :new_record?
    define_method :defaults, &block
  end

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

  def save_and_notify_changes!
    if changed?
      save_and_notify!
    else
      save!
    end
  end

  def save_and_notify!
    save!
    notify!
    self
  end

  def update_and_notify!(data)
    update! data
    notify!
    self
  end

  def self.aggregate_of(association)
    class_eval do
      define_method(:rebuild!) do |children|
        transaction do
          self.send(association).all_except(children).delete_all
          self.update! association => children
          children.each &:save!
        end
        reload
      end
    end
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
