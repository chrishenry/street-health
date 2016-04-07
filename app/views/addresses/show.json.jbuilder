json.id @address.id
json.address @address.address
json.latitude @address.latitude
json.longitude @address.longitude

json.service_requests @address.service_requests do |sr|
  json.complaint_type sr.complaint_type
  json.descriptor sr.descriptor
  json.created_date sr.created_date
  # if sr.resolution_description?
  #   json.resolution_description sr.resolution_description
  # else
  #   json.resolution_description false
  # end
end
