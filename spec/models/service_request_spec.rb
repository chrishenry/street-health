require 'rails_helper'

RSpec.describe ServiceRequest, type: :model do
  describe "update service requests" do
    it 'should update last_sr_update' do

      @time_now = Time.now
      allow(Time).to receive(:now).and_return(@time_now)

      VCR.use_cassette("geolocate", :record => :new_episodes, :allow_playback_repeats => true) do

        @address = Address.find_or_create_by_address("324 spring st")
        @retval = @address.update_service_requests()

        expect(@address.last_sr_update).to eq(@time_now)
        expect(@retval).to eq(Address::STATUS_SR_UPDATE_SUCCESS)

      end
    end
  end
end
