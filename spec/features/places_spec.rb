require "rails_helper"

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [Place.new(name: "Oljenkorsi", id: 1)]
    )

    visit places_path
    fill_in("city", with: "kumpula")
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end

  it "if multiple places are returned by the API, they are all shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("helsinki").and_return(
      [Place.new(name: "Kaisla", id: 1),
       Place.new(name: "Pikkulintu", id: 2)]
    )

    visit places_path
    fill_in("city", with: "helsinki")
    click_button "Search"

    expect(page).to have_content "Kaisla"
    expect(page).to have_content "Pikkulintu"
  end

  it "if no places are returned by the API, the correct notice is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("helsinki").and_return([])

    visit places_path
    fill_in("city", with: "helsinki")
    click_button "Search"

    expect(page).to have_content "No places in helsinki"
  end
end
