class Rating < ApplicationRecord
  belongs_to :user
  belongs_to :product
  validates_presence_of :user_id, :product_id, :rating
  validates :rating, numericality: { greater_than_or_equal_to: 1, lesser_than_or_equal_to: 5,  only_integer: true }
end
