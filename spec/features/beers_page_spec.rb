require 'rails_helper'

include Helpers

describe "Beer" do
  let!(:brewery) { FactoryBot.create :brewery, name: "Koff" }
  let!(:style) { FactoryBot.create :style }
  let!(:user) { FactoryBot.create :user }

  before :each do
    sign_in(username: "Pekka", password: "Foobar1")
  end

  it "when added with valid name, is saved" do
    visit new_beer_path
    fill_in("beer_name", with: "Lapin Kulta")
    select("Lager", from: "beer[style_id]")
    select("Koff", from: "beer[brewery_id]")

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end

  it "when added with invalid name, is not saved" do
    visit new_beer_path
    select("Lager", from: "beer[style_id]")
    select("Koff", from: "beer[brewery_id]")
    click_button "Create Beer"

    expect(Beer.count).to eq(0)
    expect(page).to have_content "Name can't be blank"
  end
end