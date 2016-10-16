
class AddressesController < ApplicationController

  class AddressParams
    def AddressParams.build(params)
      params.require(:address)
    end
  end

  def show
    ActiveRecord::Base.logger.info AddressParams.build(params)

    begin
      @address = Address.find_or_create_by_address(AddressParams.build(params))
      @address.update_service_requests()
      # TODO: be more specific when sending this error down.
    rescue => error
      render :json => { :error => error.message }, :status => 422
    end
  end

end
