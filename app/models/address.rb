class Address < ActiveRecord::Base
  has_many :service_requests

  before_save :upcase_address
  geocoded_by :address
  after_validation :geocode

  def update_service_requests
    ActiveRecord::Base.logger.info "update_service_requests"
    ActiveRecord::Base.logger.info self.address

    socrata = SocrataService.new(Rails.application.config.socrata)
    service_requests = socrata.query(self.address.upcase)

    service_requests.each do |sr|
      new_sr = ServiceRequest.find_or_initialize_by(unique_key: sr.unique_key)

      ActiveRecord::Base.logger.info new_sr

      if new_sr.new_record?
        new_sr.update_attributes({
          address_id: self.id,
          complaint_type: sr.complaint_type,
          descriptor: sr.descriptor,
          created_date: sr.created_date
        })
      end
        ActiveRecord::Base.logger.info new_sr

    end
  end

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
