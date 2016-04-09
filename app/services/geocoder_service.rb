# app/services/geocoder_service.rb

class GeocoderService

  def initialize(config={})
    @config = config

    # set city default to NY
    @config[:city] = 'New York' unless @config.has_key?(:city)
  end

  def query(address)
    Geocoder::Query.new(address + ", " + @config[:city]).execute
  end

end
