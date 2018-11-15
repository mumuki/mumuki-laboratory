class AddUpvotesCountToDiscussions < ActiveRecord::Migration[5.1]
  def change
    add_column :discussions, :upvotes_count, :integer, default: 0
  end
end
