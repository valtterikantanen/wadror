module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    ratings.reduce(0){ |sum, rating| sum + rating.score }.to_f / ratings.count
  end
end
