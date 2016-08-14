namespace :service_requests do
  desc "Grab Service Requests for the last 24 hours"
  task update: :environment do

    d = Date.today.prev_day.strftime("%Y-%m-%d %H:%M:%S")
    puts "#{d}"

    socrata = SocrataService.new(Rails.application.config.socrata)
    service_requests = socrata.query_from_created(d)

    service_requests.each do |sr|

      # Skip service requests with no address
      if sr.incident_address == '' || sr.incident_address == nil
        next
      end

      puts sr.incident_address

      addr = Address.find_or_create_by_address(sr.incident_address)
      sr = ServiceRequest.upsert(addr.id, sr)

    end

  end

end
