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

  def self.top(amount)
    Brewery.all.sort_by(&:average_rating).reverse.first(amount)
  end

  def to_s
    name.to_s
  end
end
