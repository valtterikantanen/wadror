module Top
  extend ActiveSupport::Concern

  class_methods do
    def top(amount)
      all.sort_by(&:average_rating).reverse.first(amount)
    end
  end
end
