require 'rails_helper'

class BestMatchMock

  def initialize(data)
    @data = data
  end

  def data
    @data
  end

end

RSpec.describe Address, type: :model do

  it "properly validates geocoder data" do

    best_match = BestMatchMock.new({"address_components"=>
      [{"long_name"=>"New York",
        "short_name"=>"New York",
        "types"=>["locality", "political"]},
       {"long_name"=>"New York",
        "short_name"=>"NY",
        "types"=>["administrative_area_level_1", "political"]},
       {"long_name"=>"United States",
        "short_name"=>"US",
        "types"=>["country", "political"]}],
     "formatted_address"=>"New York, NY, USA",
     "geometry"=>
      {"bounds"=>
        {"northeast"=>{"lat"=>40.91525559999999, "lng"=>-73.70027209999999},
         "southwest"=>{"lat"=>40.4960439, "lng"=>-74.2557349}},
       "location"=>{"lat"=>40.7127837, "lng"=>-74.0059413},
       "location_type"=>"APPROXIMATE",
       "viewport"=>
        {"northeast"=>{"lat"=>40.91525559999999, "lng"=>-73.70027209999999},
         "southwest"=>{"lat"=>40.4960439, "lng"=>-74.2557349}}},
     "partial_match"=>true,
     "place_id"=>"ChIJOwg_06VPwokRYv534QaPC8g",
     "types"=>["locality", "political"]})

    expect{
      Address.validate_address_components(best_match)
    }.to raise_exception(ActiveRecord::RecordNotFound)

  end

end
