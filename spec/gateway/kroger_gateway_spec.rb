require 'rails_helper'


RSpec.describe KrogerGateway, type: :service do
  let(:gateway) { KrogerGateway.instance }

  describe '#authorize_connection' do
    context 'when credentials are valid' do
      it 'retrieves an authorization token', :vcr do
        token = gateway.token

        expect(token).not_to be_nil
        expect(gateway.instance_variable_get(:@token_expires_at)).to be > Time.now
      end
    end

    context 'when credentials are invalid' do
      it 'raises an authorization error', :vcr do
        allow(Rails.application.credentials).to receive(:kroger).and_return({
          client_id: 'invalid_client_id',
          client_password: 'invalid_client_secret'
        })

        expect { gateway.authorize_connection }.to raise_error(RuntimeError, /Authorization failed/)
      end
    end
  end

  describe '#fetch_data' do
    context 'with valid authorization' do
      it 'fetches product data with a valid token', :vcr do
        search_params = { "filter.term": "milk", "filter.locationId": 62000115 }
        
        response = gateway.fetch_data("products", search_params)

        expect(response).not_to be_nil
        expect(response).to be_a(Faraday::Response)
        expect(response.status).to eq(200)

        data = JSON.parse(response.body)
        expect(data).to have_key("data")
        expect(data["data"]).to be_an(Array)
        expect(data["data"].first).to include("productId", "description")
      end
    end
  end
end