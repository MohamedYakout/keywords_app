class AddTotalResultsToKeyword < ActiveRecord::Migration
  def change
    add_column :keywords, :total_results, :integer
  end
end
