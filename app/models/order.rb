class Order < ApplicationRecord
  validates_presence_of :product_id, :user_id
  belongs_to :user
  belongs_to :product
  validates_presence_of :paypal_payment_token, :paypal_customer_token, if: :is_paid?
 
  def is_paid?
    product.exclusivity_id > Exclusivity.find_by_name('Free').id
  end

  def save_with_paypal_payment
    
    product = Product.find(self.product_id)

    request = Paypal::Express::Request.new(
      :username   => ENV['PAYPAL_USER'],
      :password   => ENV['PAYPAL_PWD'],
      :signature  => ENV['PAYPAL_SIG']
    )

    payment_request = Paypal::Payment::Request.new(
      :currency_code => 'USD',   # if nil, PayPal use USD as default
      :description   => product.name,    # item description
      :quantity      => 1,      # item quantity
      :amount        => product.price,   # item value
    )

  	response = request.checkout!(
  	  self.paypal_payment_token,
  	  self.paypal_customer_token,
  	  payment_request
  	)
    save!
    
  end
end
