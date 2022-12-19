class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, :style, presence: true

  def self.top(n)
    sorted_by_ratings_desc = Beer.all.sort_by{ |b| b.average_rating }.reverse
    sorted_by_ratings_desc[0..n-1]
  end

  def to_s
    "#{name} (#{brewery.name})"
  end
end
