
class AddressesController < ApplicationController

  class AddressParams
    def AddressParams.build(params)
      params.require(:address)
    end
  end

  def show
    ActiveRecord::Base.logger.info AddressParams.build(params)

    @address = Address.find_or_create_by_address(AddressParams.build(params))
    if @address
      @address.update_service_requests()
    end
  end

end
