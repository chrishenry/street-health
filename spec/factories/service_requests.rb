FactoryGirl.define do
  factory :service_request do
    Address nil
    unique_key "MyString"
    complaint_type "MyString"
    descriptor "MyString"
    created_date "2016-04-07 15:13:16"
  end
end
