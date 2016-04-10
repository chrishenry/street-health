require 'rails_helper'

describe AddressesController do

  describe "failing show" do
    it "raises an exception" do
      expect{ get(:show, {}) }.to raise_error ActionController::ParameterMissing
    end
  end

  describe "show" do
    before do
      # VCR.use_cassette("geolocate", :record => :new_episodes, :match_requests_on => [:method, :host, :path], :allow_playback_repeats => true) do
        Address.create!(address: '324 SPRING STREET')
        xhr :get, :show, format: :json, address: address
      # end
    end

    subject(:results) { JSON.parse(response.body) }

    context "when the search finds results" do
      let(:address) { '324 spring street' }
      it 'should 200' do
        expect(response.status).to eq(200)
      end
    end

    context "when there is an invalid address" do
      let(:address) { 'not a real address' }
      it 'should 404' do
        expect(response.status).to eq(404)
      end
    end

  end
end
