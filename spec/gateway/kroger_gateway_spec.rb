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
      it 'raises an authorization error' do
        allow(Rails.application.credentials).to receive(:kroger).and_return({
          client_id: 'invalid_client_id',
          client_password: 'invalid_client_secret'
        })

        stub_request(:post, "https://api.kroger.com/v1/connect/oauth2/token")
          .to_return(status: 401, body: { error: "invalid_client" }.to_json, headers: { 'Content-Type' => 'application/json' })
      
        expect { gateway.authorize_connection }.to raise_error(RuntimeError, /Authorization failed/)
      
      end
    end
  end

  describe '#fetch_data' do
    context 'with valid authorization' do
      it 'fetches product data with a valid token' do
        VCR.turned_off do
          WebMock.allow_net_connect! 
    
          stub_request(:get, "https://api.kroger.com/v1/products")
            .with(query: { "filter.term" => "milk", "filter.locationId" => 62000115 },
                  headers: { "Authorization" => "Bearer mocked_valid_token" })
            .to_return(
              status: 200,
              body: {
                data: [
                  { productId: "12345", description: "Milk" }
                ]
              }.to_json,
              headers: { 'Content-Type' => 'application/json' }
            )
    
          allow(gateway).to receive(:token).and_return('mocked_valid_token')
    
          search_params = { "filter.term": "milk", "filter.locationId": 62000115 }
          response = gateway.fetch_data("products", search_params)
    
          expect(response).not_to be_nil
          expect(response).to be_a(Faraday::Response)
          expect(response.status).to eq(200)
    
          data = JSON.parse(response.body)
          expect(data).to have_key("data")
          expect(data["data"]).to be_an(Array)
          expect(data["data"].first).to include("productId", "description")
    
          WebMock.disable_net_connect! 
        end
      end      
    end
  end

  describe '#authorize_location_token' do
    context 'when credentials are valid' do
      it 'retrieves an authorization token for location data', :vcr do
        token = gateway.location_token

        expect(token).not_to be_nil
        expect(gateway.instance_variable_get(:@location_token_expires_at)).to be > Time.now
      end
    end


    context 'when credentials are invalid' do
      it 'raises an authorization error' do

        allow(Rails.application.credentials).to receive(:kroger).and_return({
          client_id: 'invalid_client_id',
          client_password: 'invalid_client_secret'
        })


        stub_request(:post, "https://api.kroger.com/v1/connect/oauth2/token")
          .to_return(
            status: 401,
            body: { error: "invalid_client" }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )


        expect { gateway.authorize_location_token }.to raise_error(RuntimeError, /Location token authorization failed/)
      end
    end
  end

  describe '#fetch_location_data' do
    context 'with valid location authorization' do
      it 'fetches location data with a valid location token' do

        allow(gateway).to receive(:location_token).and_return('mocked_valid_token')
        location_params = { "filter.zipCode.near": "45202" }

        stub_request(:get, "https://api.kroger.com/v1/locations")
          .with(
            query: location_params,
            headers: { "Authorization" => "Bearer mocked_valid_token" }
          )
          .to_return(
            status: 200,
            body: {
              data: [
                { locationId: "12345", name: "Sample Location", address: "123 Main St" }
              ]
            }.to_json,
            headers: { 'Content-Type' => 'application/json' }
          )

 
        response = gateway.fetch_location_data("locations", location_params)

        expect(response).not_to be_nil
        expect(response).to be_a(Faraday::Response)
        expect(response.status).to eq(200)

        data = JSON.parse(response.body)
        expect(data).to have_key("data")
        expect(data["data"]).to be_an(Array)
        expect(data["data"].first).to include("locationId", "name", "address")
      end
    end
  end
end