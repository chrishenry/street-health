require 'rails_helper'

describe AddressesController do

  describe "failing show" do
    it "raises an exception" do
      expect{ get(:show, {}) }.to raise_error ActionController::ParameterMissing
    end
  end

  describe "show" do
    before do
      Address.create!(address: '324 SPRING STREET')

      xhr :get, :show, format: :json, address: address
    end

    subject(:results) { JSON.parse(response.body) }

    # def extract_name
    #   ->(object) { object["address"] }
    # end

    context "when the search finds results" do
      let(:address) { '324 spring street' }
      it 'should 200' do
        expect(response.status).to eq(200)
      end
    end

  end
end
