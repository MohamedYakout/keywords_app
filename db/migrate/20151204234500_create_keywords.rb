class CreateKeywords < ActiveRecord::Migration
  def change
    create_table :keywords do |t|
      t.string :word
      t.text :page

      t.timestamps null: false
    end
    add_index :keywords, :word, unique: true
  end
end
