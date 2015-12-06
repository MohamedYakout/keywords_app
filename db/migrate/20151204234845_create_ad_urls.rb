class CreateAdUrls < ActiveRecord::Migration
  def change
    create_table :ad_urls do |t|
      t.text :link, :limit => 4294967295
      t.string :position
      t.boolean :is_ad

      t.timestamps null: false
    end
  end
end
