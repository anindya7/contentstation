class CreateProducts < ActiveRecord::Migration[5.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :author
      t.belongs_to :industry, foreign_key: true
      t.integer :word_length
      t.string :exclusivity
      t.integer :complexity
      t.integer :price
      t.timestamps
    end
  end
end
