module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    return 0.0 if ratings.empty?

    ratings.reduce(0){ |sum, rating| sum + rating.score }.to_f / ratings.count
  end
end
