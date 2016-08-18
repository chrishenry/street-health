class ServiceRequest < ActiveRecord::Base
  belongs_to :Address

  def ServiceRequest.upsert(address_id, service_request)
    new_sr = ServiceRequest.find_or_initialize_by(unique_key: service_request.unique_key)

    ActiveRecord::Base.logger.info service_request

    if new_sr.new_record?
      new_sr.update_attributes({
        address_id: address_id,
        complaint_type: service_request.complaint_type,
        descriptor: service_request.descriptor,
        created_date: service_request.created_date,
        status: service_request.status,
        resolution_description: service_request.resolution_description
      })
    end

    ActiveRecord::Base.logger.info new_sr

    new_sr
  end

end
