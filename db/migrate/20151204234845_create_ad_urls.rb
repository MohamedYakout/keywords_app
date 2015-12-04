class CreateAdUrls < ActiveRecord::Migration
  def change
    create_table :ad_urls do |t|
      t.string :link
      t.string :position
      t.boolean :is_ad

      t.timestamps null: false
    end
  end
end
