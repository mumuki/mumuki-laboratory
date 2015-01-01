class IncrementLanguageId < ActiveRecord::Migration
  def change
    execute 'update exercises set language_id = language_id + 1'
  end
end
