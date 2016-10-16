class AddLastSrUpdateToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :last_sr_update, :datetime
  end
end
