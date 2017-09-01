class AddUnitIdToComplement < ActiveRecord::Migration
  def change
    #TODO also migrate and remove book_id: create a new unit, add it to the organizations that have the book, and add all complements to such units
    add_reference :complements, :unit, index: true
  end
end
