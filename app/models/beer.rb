class Beer < ApplicationRecord
  belongs_to :brewery
  has_many :ratings

  def average_rating
    ratings.reduce(0){ |sum, rating| sum + rating.score }.to_f / ratings.count
  end

  def to_s
    "#{name} (#{brewery.name})"
  end
end
