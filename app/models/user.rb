class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def ordered_products
    Product.all.select {|prod| prod.ordered_by_user?(self.id) }
  end

  def has_rated_product?(product)
  	Rating.where(user_id: self.id, product_id: product).any?
  end
end
