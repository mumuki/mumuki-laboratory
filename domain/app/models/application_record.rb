class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  delegate :whitelist_attributes, to: :class

  def self.defaults(&block)
    after_initialize :defaults, if: :new_record?
    define_method :defaults, &block
  end

  def self.all_except(others)
    if others.present?
      where.not(id: [others.map(&:id)])
    else
      all
    end
  end

  def self.serialize_symbolized_hash_array(*keys)
    keys.each do |field|
      serialize field
      define_method(field) { self[field]&.map { |it| it.symbolize_keys } }
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

  def self.whitelist_attributes(a_hash, options={})
    attributes = attribute_names
    attributes += reflections.keys if options[:relations]
    a_hash.with_indifferent_access.slice(*attributes).except(*options[:except])
  end
end
