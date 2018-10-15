module Mumuki::Domain::Status
  extend ActiveSupport::Concern

  included do
    to_status_method_name = to_status_method
    base = self
    String.send :define_method, to_status_method_name, proc { to_sym.send(to_status_method_name) }
    Symbol.send :define_method, to_status_method_name, proc { base.from_sym(self) }
    define_method to_status_method_name, proc { self }
  end

  def to_s
    name.demodulize.underscore
  end

  def to_i
    parent::STATUSES.index(self)
  end

  def to_sym
    to_s.to_sym
  end

  def ==(other)
    self.equal? parent.to_mumuki_status(other) rescue false
  end

  class_methods do
    def load(i)
      cast(i)
    end

    def dump(status)
      if status.is_a? Numeric
        status
      else
        to_mumuki_status(status).to_i
      end
    end

    def test_selectors
      self::STATUSES.map { |it| "#{it}?".to_sym }
    end

    def to_mumuki_status(status)
      status.send(to_status_method)
    end

    def to_status_method
      "to_#{self}_status"
    end

    def from_sym(status)
      "Mumuki::Domain::Status::#{module_namespace(self)}::#{module_namespace(status)}".constantize
    end

    def module_namespace(mod)
      mod.to_s.camelize
    end

    def cast(i)
      self::STATUSES[i.to_i] if i.present?
    end

    def to_s
      name.demodulize.underscore
    end
  end
end

require_relative './status/submission/submission'
require_relative './status/discussion/discussion'
