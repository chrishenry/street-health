json.(address, :unique_key, :location, :complaint_type, :descriptor, :created_date)

if address.resolution_description?
  json.resolution_description address.resolution_description
else
  json.resolution_description false
end
