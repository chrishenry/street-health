class AddStatusToServiceRequest < ActiveRecord::Migration
  def change
    add_column :service_requests, :status, :string
    add_column :service_requests, :resolution_description, :string
  end
end
