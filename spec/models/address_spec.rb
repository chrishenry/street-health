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

  it "raises exception if fields aren't present" do

    best_match = BestMatchMock.new({"address_components"=>
      [{"long_name"=>"New York",
        "short_name"=>"New York",
        "types"=>["locality", "political"]},
       {"long_name"=>"New York",
        "short_name"=>"NY",
        "types"=>["administrative_area_level_1", "political"]},
       {"long_name"=>"United States",
        "short_name"=>"US",
        "types"=>["country", "political"]}]
        })

    expect{
      Address.validate_address_components(best_match)
    }.to raise_exception(ActiveRecord::RecordNotFound)

  end

  it "doesn't raise exception if all fields required are present" do
    best_match = BestMatchMock.new({"address_components"=>
      [{"long_name"=>"New York",
        "short_name"=>"New York",
        "types"=>["route", "street_number", "neighborhood", "postal_code"]}]})

    Address.validate_address_components(best_match)
  end

end
