class Exclusivity < ApplicationRecord
  has_many :products
  validates_presence_of :name, :count
  validates :count, numericality: { greater_than_or_equal_to: 0,  only_integer: true }
end
