class AddPaypalFieldsToOrders < ActiveRecord::Migration[5.1]
  def change
  	add_column :orders, :paypal_customer_token, :string
  	add_column :orders, :paypal_payment_token, :string
  end
end
