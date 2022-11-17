require 'rails_helper'

RSpec.describe User, type: :model do
  it "has the username set correctly" do
    user = User.new username: "Pekka"

    expect(user.username).to eq("Pekka")
  end

  it "is not saved without a password" do
    user = User.create username: "Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "with a proper password" do
    let(:user){ FactoryBot.create(:user) }
    let(:test_brewery) { Brewery.new name: "test", year: 2000 }
    let(:test_beer) { Beer.create name: "testbeer", style: "teststyle", brewery: test_brewery }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      FactoryBot.create(:rating, score: 10, user: user)
      FactoryBot.create(:rating, score: 20, user: user)

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  it "with a too short password is not saved" do
    user = User.create username: "Pekka", password: "aa", password_confirmation: "aa"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "with a password containing only letters is not saved" do
    user = User.create username: "Pekka", password: "salasana", password_confirmation: "salasana"
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beers_with_many_ratings( { user: user }, 10, 20, 15, 7, 9)
      best = create_beer_with_rating( { user: user }, 25)

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite style" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the style of the only rated beer if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the style with highest average rating if several rated" do
      create_many_beers_with_styles_and_ratings(
        { user: user },
        { style: "Lager", score: 30 },
        { style: "Lager", score: 34 },
        { style: "IPA", score: 50 },
        { style: "IPA", score: 15 }
      )

      expect(user.favorite_style).to eq("IPA")
    end
  end

  describe "favorite brewery" do
    let(:user){ FactoryBot.create(:user) }

    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end

    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end

    it "is the brewery of the only rated beer if only one rating" do
      beer = FactoryBot.create(:beer)
      rating = FactoryBot.create(:rating, score: 20, beer: beer, user: user)

      expect(user.favorite_brewery).to eq(beer.brewery.name)
    end

    it "is the brewery with highest average rating if several rated" do
      brewdog = FactoryBot.create(:brewery, name: "brewdog")
      testdog = FactoryBot.create(:brewery, name: "testdog")
      create_many_beers_with_breweries_and_ratings(
        { user: user },
        { brewery: brewdog, score: 30 },
        { brewery: brewdog, score: 34 },
        { brewery: testdog, score: 50 },
        { brewery: testdog, score: 15 }
      )

      expect(user.favorite_brewery).to eq(testdog.name)
    end
  end
end

def create_beer_with_rating(object, score)
  beer = FactoryBot.create(:beer)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
  beer
end

def create_beers_with_many_ratings(object, *scores)
  scores.each do |score|
    create_beer_with_rating(object, score)
  end
end

def create_beer_with_style_and_rating(object, style, score)
  beer = FactoryBot.create(:beer, style: style)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
end

def create_many_beers_with_styles_and_ratings(object, *styles_and_ratings)
  styles_and_ratings.each do |style_and_rating|
    create_beer_with_style_and_rating(object, style_and_rating[:style], style_and_rating[:score])
  end
end

def create_beer_with_brewery_and_rating(object, brewery, score)
  beer = FactoryBot.create(:beer, brewery: brewery)
  FactoryBot.create(:rating, beer: beer, score: score, user: object[:user])
end

def create_many_beers_with_breweries_and_ratings(object, *breweries_and_ratings)
  breweries_and_ratings.each do |brewery_and_rating|
    create_beer_with_brewery_and_rating(object, brewery_and_rating[:brewery], brewery_and_rating[:score])
  end
end