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

end
