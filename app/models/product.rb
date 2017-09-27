class Product < ApplicationRecord
  scope :by_industry, lambda { |ind| where(:industry_id => ind)}
  scope :by_word_length, lambda { |wl| where("word_length <= ?", wl)}
  scope :by_price, lambda { |price| where('price <= ?', price)}
  scope :by_rating, lambda { |rating| select { |prod| prod.ratings.any? && prod.average_rating.to_f >= rating.to_f } }
  scope :by_author, lambda { |author| where('lower(author) LIKE lower(?)', "%#{author}%")}
  scope :by_complexity, lambda { |comp| where(:complexity => comp)}
  scope :by_exclusivity, lambda { |ex| where(:exclusivity_id => ex)}

  belongs_to :industry
  belongs_to :exclusivity
  has_many :taggings
  has_many :tags, through: :taggings
  has_many :ratings
  has_many :orders
  validates_presence_of :name, :author, :industry_id, :word_length, :exclusivity, :complexity, :price, :file_url
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :word_length, numericality: { greater_than_or_equal_to: 1,  only_integer: true }
  validates :complexity, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 5,  only_integer: true }
  paginates_per 1

  def has_been_ordered?
    orders.any?
  end

  def ordered_by_user?(user)
    orders.where(user_id: user).any?
  end

  def average_rating
    ratings.average(:rating)
  end

end
