require 'rails_helper'

include Helpers

describe "Rating" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:beer1) { FactoryBot.create :beer, name: "iso 3", brewery:brewery }
  let!(:beer2) { FactoryBot.create :beer, name: "Karhu", brewery:brewery }
  let!(:user) { FactoryBot.create :user }
  let!(:user2) { FactoryBot.create :user, username: "Matti" }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
    FactoryBot.create :rating, score: 10, user: user
    FactoryBot.create :rating, score: 26, user: user
    FactoryBot.create :rating, score: 32, user: user
    FactoryBot.create :rating, score: 49, user: user
    FactoryBot.create :rating, score: 44, user: user2
  end

  it "when given, is registered to the beer and user who is signed in" do
    Rating.destroy_all
    visit new_rating_path
    select('iso 3', from: 'rating[beer_id]')
    fill_in('rating[score]', with: '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "on all ratings page are visible" do
    visit ratings_path

    expect(Rating.count).to eq(5)
    expect(page).to have_content "Total ratings: 5"
    expect(page).to have_content "anonymous 32 Pekka"
  end

  it "visible on user page are user's own ratings" do
    visit user_path(user)

    expect(Rating.count).to eq(5)
    expect(page).to have_content "Has made 4 ratings"
    expect(page).to have_content "anonymous 32 Delete"
    expect(page).not_to have_content "anonymous 44 Delete"
  end

  it "when deleting own rating it is removed" do
    visit user_path(user)
    click_link("", href: "/ratings/1")

    expect(Rating.count).to eq(4)
    expect(page).to have_content "Has made 3 ratings"
    expect(page).not_to have_content "anonymous 10 Delete"
  end
end