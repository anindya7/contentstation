class Product < ApplicationRecord
  scope :by_industry, lambda { |ind| where(:industry_id => ind)}
  scope :by_word_length, lambda { |wl| where("word_length <= ?", wl)}
  scope :by_price, lambda { |price| where('price <= ?', price)}
  scope :by_rating, lambda { |rating| where('rating >=', rating)}
  scope :by_author, lambda { |author| where('lower(author) LIKE lower(?)', "%#{author}%")}
  scope :by_complexity, lambda { |comp| where(:complexity => comp)}
  scope :by_exclusivity, lambda { |ex| where('lower(exclusivity) = lower(?)', ex)}

  belongs_to :industry
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  validates_presence_of :name, :author, :industry_id, :word_length, :exclusivity, :complexity, :price, :file_url
  validates :price, numericality: { greater_than_or_equal_to: 0,  only_integer: true }
  validates :word_length, numericality: { greater_than_or_equal_to: 1,  only_integer: true }
  validates :complexity, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5,  only_integer: true }
  paginates_per 1

  def has_been_ordered?
    Order.where(product_id: self.id).any?
  end

  def ordered_by_user?(user)
    Order.where(product_id: self.id, user_id: user).any?
  end

end
