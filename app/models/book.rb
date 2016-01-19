class Book < ActiveRecord::Base
  include WithMarkup

  validates_presence_of :name, :locale

  markup_on :preface

  before_create :setup_apartment_tenant!
  after_destroy :teardown_apartment_tenant!

  def switch!
    Apartment::Tenant.switch! name
  end

  def rebuild!(chapters)
    transaction do
      Chapter.delete_all
      chapters.each_with_index do |it, index|
        it.number = index + 1
        it.save!
      end
      save!
    end
  end

  def self.current
    raise 'book not selected' if Apartment::Tenant.on? 'public'
    find_by name: Apartment::Tenant.current
  end

  def self.central
    find_by name: 'central'
  end

  private

  def teardown_apartment_tenant!
    Apartment::Tenant.teardown name
  end

  def setup_apartment_tenant!
    Apartment::Tenant.setup name
  end
end
