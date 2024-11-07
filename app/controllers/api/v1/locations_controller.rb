class Api::V1::LocationsController < ApplicationController
  def index
    unless params[:lat] && params[:long]
      error = ErrorMessage.new("Latitude and longitude are required parameters", :unprocessable_entity)
      return render json: ErrorSerializer.format_error(error), status: error.status_code
    end

    response = KrogerGateway.instance.fetch_location_data("locations", location_params)

    unless response.success?
      error = ErrorMessage.new("Failed to fetch location data: #{response.status} #{response.reason_phrase}", :unprocessable_entity)
      return render json: ErrorSerializer.format_error(error), status: error.status_code
    end


    data = JSON.parse(response.body)["data"]

    render json: LocationsSerializer.format(data), status: :ok
  end

  private

  def location_params
    { "filter.latLong.near" => "#{params[:lat]},#{params[:long]}", "filter.radiusInMiles" => "4" }
  end
end