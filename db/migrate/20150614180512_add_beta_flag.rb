class AddBetaFlag < ActiveRecord::Migration
  def change
    add_column :guides, :beta, :boolean, default: false
  end
end
