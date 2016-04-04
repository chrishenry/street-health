require 'rails_helper'

describe AddressesController do
  render_views
  describe "index" do
    before do
      Address.create!(address: '324 Spring St')
      Address.create!(address: '532 Broadway')
      Address.create!(address: '97 Macdougal St')
      Address.create!(address: '10 Downing St')

      xhr :get, :index, format: :json, address: address
    end

    subject(:results) { JSON.parse(response.body) }

    def extract_name
      ->(object) { object["address"] }
    end

    context "when the search finds results" do
      let(:address) { 'spring' }
      it 'should 200' do
        expect(response.status).to eq(200)
      end
    end

    context "when the search doesn't find results" do
      let(:address) { 'foo' }
      it 'should return no results' do
        expect(results.size).to eq(0)
      end
    end

  end
end
