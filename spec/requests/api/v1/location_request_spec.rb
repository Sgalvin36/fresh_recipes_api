require 'rails_helper'

RSpec.describe Api::V1::LocationsController, type: :controller do
  describe 'GET #index' do
    context 'when latitude and longitude are provided' do
      let(:valid_params) { { lat: 39.7392358, long: -104.990251 } }

      it 'returns location data with a valid response', :vcr do
        get :index, params: valid_params

        expect(response).to have_http_status(:ok)
        body = JSON.parse(response.body)

        expect(body).to have_key("data")
        expect(body["data"]).to be_an(Array)

        first_location = body["data"].first
        expect(first_location).to include(
          "locationId", "storeNumber", "name", "address", "geolocation"
        )
        
        expect(first_location["address"]).to include("addressLine1", "city", "state", "zipCode", "county")
        expect(first_location["geolocation"]).to include("latitude", "longitude")
      end
    end

    context 'when latitude and longitude are missing' do
      it 'returns an error response' do
        get :index

        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        
        expect(body).to include(
          "message" => "Latitude and longitude are required parameters",
          "status" => "unprocessable_entity"
        )
      end
    end

    context 'when external API request fails' do
      let(:valid_params) { { lat: 39.7392358, long: -104.990251 } }

      it 'returns an error response', :vcr do
        allow(KrogerGateway.instance).to receive(:fetch_location_data).and_return(
          instance_double(Faraday::Response, success?: false, status: 500, reason_phrase: "Internal Server Error")
        )

        get :index, params: valid_params

        expect(response).to have_http_status(:unprocessable_entity)
        body = JSON.parse(response.body)
        
        expect(body).to include(
          "message" => "Failed to fetch location data: 500 Internal Server Error",
          "status" => "unprocessable_entity"
        )
      end
    end
  end
end
