class Order < ApplicationRecord
  validates_presence_of :product_id, :user_id
  belongs_to :user
  belongs_to :product
end
