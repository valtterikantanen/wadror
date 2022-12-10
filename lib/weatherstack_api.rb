class WeatherstackApi
  def self.get_weather_data(city)
    url = "http://api.weatherstack.com/current?access_key=#{key}&query=#{ERB::Util.url_encode(city)}&units=m"

    response = HTTParty.get "#{url}"
    weather_data = response.parsed_response
  end

  def self.key
    # API is not needed for testing
    return nil if Rails.env.test?
    raise "Environment variable `WEATHERSTACK_API_KEY` not defined" if ENV["WEATHERSTACK_API_KEY"].nil?

    ENV.fetch("WEATHERSTACK_API_KEY")
  end
end
