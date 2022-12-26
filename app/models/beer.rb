class Beer < ApplicationRecord
  include RatingAverage
  include Top

  belongs_to :brewery, touch: true
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, -> { distinct }, through: :ratings, source: :user

  validates :name, :style, presence: true

  def to_s
    "#{name} (#{brewery.name})"
  end
end
