class Expectation < ActiveRecord::Base
  validates_presence_of :binding, :inspection
end
