require 'pp'

class Address < ActiveRecord::Base
  has_many :service_requests

  before_save :upcase_address

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
      raise ArgumentError.new("Hmmm, can't find that address. Try something like '324 Spring Street'")
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
    geo_query = GeocoderService.new.query(address + ", NY")

    ActiveRecord::Base.logger.info pp(geo_query)

    # geo_query[0].data needs to have a street_number or route type address component
    # TODO: probably raise an error to be handled elsewhere
    if geo_query.length == 0
      return false
    end

    # TODO: consider iterating through results for a best match
    # TODO: break this logic out into it's own, more testable function
    best_match = geo_query[0]

    if not best_match.data.has_key?('address_components')
      raise ActiveRecord::RecordNotFound
    end

    ActiveRecord::Base.logger.info pp(best_match.data)
    validate_address_components(best_match)

    address = get_address_from_geo_query(best_match)
    ActiveRecord::Base.logger.info address

    addr = self.find_or_initialize_by(address: address)
    addr.update_attributes({
      address: address,
      latitude: best_match.coordinates()[0],
      longitude: best_match.coordinates()[1]
    })

    addr.save

    addr

  end

  # TODO: implement recency logic. If address has updated date of older than X, update service requests
  def update_service_requests
    ActiveRecord::Base.logger.info "update_service_requests"
    ActiveRecord::Base.logger.info self.address

    socrata = SocrataService.new(Rails.application.config.socrata)
    service_requests = socrata.query_by_address(self.address.upcase)

    ActiveRecord::Base.logger.info "sr.len: #{service_requests.length}"
    ActiveRecord::Base.logger.info service_requests

    if service_requests.kind_of?(Array)
      service_requests.each do |sr|
        ServiceRequest.upsert(self.id, sr)
      end
    end

  end

  def geocode_address()
    address + ", NY"
  end

  private

    def upcase_address
      self.address = address.upcase
    end


end
