class Address < ActiveRecord::Base

  def self.search_socrata(address)
    socrata = SocrataService.new(Rails.application.config.socrata)
    socrata.query(address.upcase)
  end

end
