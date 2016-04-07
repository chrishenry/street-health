class AddressesController < ApplicationController

  def index
    @addresses = if params[:address]
                 Address.search_socrata(params[:address])
               else
                 []
               end

  end

end
