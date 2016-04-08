class CreateServiceRequests < ActiveRecord::Migration
  def change
    create_table :service_requests do |t|
      t.references :address, index: true, foreign_key: true
      t.string :unique_key
      t.string :complaint_type
      t.string :descriptor
      t.datetime :created_date

      t.timestamps null: false
    end
  end
end
