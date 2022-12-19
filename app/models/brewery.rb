class Brewery < ApplicationRecord
  include RatingAverage

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { only_integer: true }
  validate :year_must_be_in_the_correct_range

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def year_must_be_in_the_correct_range
    current_year = Time.now.year
    return unless !year.nil? && (year < 1040 || year > current_year)

    errors.add(:year, "must be between 1040 and #{current_year}")
  end

  def self.top(n)
    sorted_by_ratings_desc = Brewery.all.sort_by{ |b| b.average_rating }.reverse
    sorted_by_ratings_desc[0..n-1]
  end

  def to_s
    name.to_s
  end
end
