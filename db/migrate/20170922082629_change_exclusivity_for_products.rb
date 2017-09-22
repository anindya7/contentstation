class ChangeExclusivityForProducts < ActiveRecord::Migration[5.1]
  def change
    remove_column :products, :exclusivity
    add_column :products, :exclusivity_id, :integer
  end
end
