class AddressesController < ApplicationController

  def index
    @addresses = if params[:address]
                 Address.where('address LIKE ?',"%#{params[:address]}%")
               else
                 []
               end
  end

end
