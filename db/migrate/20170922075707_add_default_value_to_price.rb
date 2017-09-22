class AddDefaultValueToPrice < ActiveRecord::Migration[5.1]
  def change
    change_column :products, :price, :integer, :default => 0
  end
end
