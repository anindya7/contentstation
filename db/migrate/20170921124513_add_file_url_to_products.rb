class AddFileUrlToProducts < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :file_url, :string
  end
end
