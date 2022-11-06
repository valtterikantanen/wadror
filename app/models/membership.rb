class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :beer_club

  validate :user_is_not_member_of_club

  def user_is_not_member_of_club
    return unless Membership.find_by user_id: user.id, beer_club_id: beer_club_id

    errors.add(:user, "is already a member of the club")
  end
end
