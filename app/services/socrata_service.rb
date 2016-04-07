# app/services/socrata_service.rb

require 'soda/client'

class SocrataService
  def initialize(config)
    # @app_secret = config[:app_secret]
    @config = config
    @client = SODA::Client.new({:domain => config[:domain], :app_token => config[:app_token]})
  end

  def query(address)
    begin
      response = @client.get(@config[:dataset_id], {"$limit" => 50, :incident_address => address})
    rescue Exception => e
      return e.message + " " + e.backtrace.inspect
    end
  end

  def create_customer
    begin
      # This will return a Stripe::Customer object
      external_customer_service.create(customer_attributes)
    rescue
      false
    end
  end

  private

  attr_reader :card, :amount, :email

  def external_charge_service
    Stripe::Charge
  end

  def external_customer_service
    Stripe::Customer
  end

  def charge_attributes
    {
      amount: amount,
      card: card
    }
  end

  def customer_attributes
    {
      email: email,
      card: card
    }
  end
end
