class Address < ActiveRecord::Base
  has_many :service_requests

  before_save :upcase_address
  geocoded_by :geocode_address
  after_validation :geocode

  def Address.validate_address_components(best_match)

    req_count = 0
    required_address_components = %w{route street_number neighborhood postal_code}
    required_address_components.each do |req|
      best_match.data['address_components'].each do |ac|
        if ac['types'].include?(req)
          req_count += 1
          break
        end
      end
    end

    if req_count < required_address_components.length
      raise ActiveRecord::RecordNotFound
    end

  end

  # Street number + route long name (all uppercase)
  def Address.get_address_from_geo_query(match)

    num = match.data['address_components'].find {|c| c['types'].include?('street_number') }
    route = match.data['address_components'].find {|c| c['types'].include?('route') }

    retval = num['long_name'] + ' ' + route['long_name']
    retval.upcase

  end

  def Address.find_or_create_by_address(address)

    address = address.upcase

    # Pretty inefficient, as this will query, and then the geocoded_by will make a call
    # TODO: actually use the info from the geo query response
    geo_query = GeocoderService.new.query(address + ", NY")

    require 'pp'
    ActiveRecord::Base.logger.info pp(geo_query)

    # geo_query[0].data needs to have a street_number or route type address component
    if geo_query.length == 0
      return false
    end

    # TODO: consider iterating through results for a best match
    # TODO: break this logic out into it's own, more testable function
    best_match = geo_query[0]
    # ActiveRecord::Base.logger.info pp(best_match)

    if not best_match.data.has_key?('address_components')
      raise ActiveRecord::RecordNotFound
    end

    ActiveRecord::Base.logger.info pp(best_match.data)
    validate_address_components(best_match)

    address = get_address_from_geo_query(best_match)
    ActiveRecord::Base.logger.info address

    self.find_or_create_by(address: address)
  end

  def update_service_requests
    ActiveRecord::Base.logger.info "update_service_requests"
    ActiveRecord::Base.logger.info self.address

    socrata = SocrataService.new(Rails.application.config.socrata)
    service_requests = socrata.query(self.address.upcase)

    service_requests.each do |sr|
      new_sr = ServiceRequest.find_or_initialize_by(unique_key: sr.unique_key)

      ActiveRecord::Base.logger.info sr

      if new_sr.new_record?
        new_sr.update_attributes({
          address_id: self.id,
          complaint_type: sr.complaint_type,
          descriptor: sr.descriptor,
          created_date: sr.created_date,
          status: sr.status,
          resolution_description: sr.resolution_description
        })
      end

      ActiveRecord::Base.logger.info new_sr
    end

  end

  def geocode_address()
    address + ", NY"
  end

  def self.search_socrata(address)
    socrata = SocrataService.new(Rails.application.config.socrata)
    socrata.query(address.upcase)
  end

  private

    def upcase_address
      self.address = address.upcase
    end


end
