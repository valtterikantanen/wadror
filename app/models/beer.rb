class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, :style, presence: true

  def self.top(amount)
    Beer.all.sort_by(&:average_rating).reverse.first(amount)
  end

  def to_s
    "#{name} (#{brewery.name})"
  end
end
