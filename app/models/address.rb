class Address < ActiveRecord::Base

  before_save :upcase_address
  geocoded_by :address
  after_validation :geocode

  def self.search_socrata(address)
    socrata = SocrataService.new(Rails.application.config.socrata)
    socrata.query(address.upcase)
  end

  private

    def upcase_address
      self.address = address.upcase
    end

    def geocode_validate
    end

end
