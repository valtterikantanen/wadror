class BeermappingApi
  def self.places_in(city)
    city = city.downcase

    places = Rails.cache.read(city)
    return places if places

    places = get_places_in(city)
    Rails.cache.write(city, places, expires_in: 1.weeks)
    places
  end

  def self.get_places_in(city)
    url = "https://beermapping.com/webservice/loccity/#{key}/"

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response["bmp_locations"]["location"]

    return [] if places.is_a?(Hash) && places["id"].nil?

    places = [places] if places.is_a?(Hash)
    places.map do |place|
      Place.new(place)
    end
  end

  def self.get_place(id)
    url = "https://beermapping.com/webservice/locquery/#{key}/"

    response = HTTParty.get "#{url}#{id}"
    place = response.parsed_response["bmp_locations"]["location"]

    return nil if place["id"] == "0"

    Place.new(place)
  end

  def self.key
    # API is not needed for testing
    return nil if Rails.env.test?
    raise "Environment variable `BEER_MAPPING_API_KEY` not defined" if ENV["BEER_MAPPING_API_KEY"].nil?

    ENV.fetch("BEER_MAPPING_API_KEY")
  end
end
