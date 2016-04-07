class AddressesController < ApplicationController

  def show
    @address = if params[:address]
                  Address.find_or_create_by(address: params[:address].upcase)
                else
                  []
                end

  end

end
