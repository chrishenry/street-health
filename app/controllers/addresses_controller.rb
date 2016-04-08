class AddressesController < ApplicationController

  def show
    @address = if params[:address]
                  Address.find_or_create_by(address: params[:address].upcase)
                else
                  []
                end

    ActiveRecord::Base.logger.info @address.address
    @address.update_service_requests()

  end

end
