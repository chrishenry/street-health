
class AddressesController < ApplicationController

  class AddressParams
    def AddressParams.build(params)
      params.require(:address)
    end
  end

  def show
    ActiveRecord::Base.logger.info AddressParams.build(params)

    geo_query = GeocoderService.new.query(AddressParams.build(params))

    require 'pp'
    ActiveRecord::Base.logger.info pp(geo_query)

    @address = Address.find_or_create_by(address: AddressParams.build(params).upcase)
    @address.update_service_requests() unless @address
  end

end
