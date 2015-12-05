class AddKeywordIdToAdUrl < ActiveRecord::Migration
  def change
    add_column :ad_urls, :keyword_id, :integer
  end
end
