require 'singleton'

class KrogerGateway
  include Singleton

  def initialize
    @token = nil
    @token_expires_at = nil
    @location_token = nil
    @location_token_expires_at = nil
  end

  def authorize_connection
    client_id = Rails.application.credentials.dig(:kroger, :client_id) || ENV['KROGER_CLIENT_ID']
    client_secret = Rails.application.credentials.dig(:kroger, :client_password) || ENV['KROGER_CLIENT_PASSWORD']
    encoded_credentials = Base64.strict_encode64("#{client_id}:#{client_secret}")

    response = Faraday.post("https://api.kroger.com/v1/connect/oauth2/token") do |req|
      req.headers = {
        "Authorization" => "Basic #{encoded_credentials}",
        "Cache-Control" => "no-cache",
        "Content-Type" => "application/x-www-form-urlencoded"
      }
      req.body = {
        grant_type: "client_credentials",
        scope: "product.compact"
      }
    end

    if response.success?
      data = JSON.parse(response.body)
      @token = data["access_token"]
      @token_expires_at = Time.now + data["expires_in"].to_i
    else
      raise "Authorization failed: #{response.body}"
    end
  end

  def authorize_location_token
    client_id = Rails.application.credentials.dig(:kroger, :client_id) || ENV['KROGER_CLIENT_ID']
    client_secret = Rails.application.credentials.dig(:kroger, :client_password) || ENV['KROGER_CLIENT_PASSWORD']
    encoded_credentials = Base64.strict_encode64("#{client_id}:#{client_secret}")

    response = Faraday.post("https://api.kroger.com/v1/connect/oauth2/token") do |req|
      req.headers = {
        "Authorization" => "Basic #{encoded_credentials}",
        "Cache-Control" => "no-cache",
        "Content-Type" => "application/x-www-form-urlencoded"
      }
      req.body = {
        grant_type: "client_credentials",
        scope: "product.compact"
      }
    end

    if response.success?
      data = JSON.parse(response.body)
      @location_token = data["access_token"]
      @location_token_expires_at = Time.now + data["expires_in"].to_i
    else
      raise "Location token authorization failed: #{response.body}"
    end
  end

  def token
    if @token.nil? || Time.now >= @token_expires_at
      authorize_connection
    end
    @token
  end

  def location_token
    if @location_token.nil? || Time.now >= @location_token_expires_at
      authorize_location_token
    end
    @location_token
  end

  def connection
    Faraday.new(
      url: "https://api.kroger.com/v1/",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{token}"
      }
    )
  end

  def location_connection
    Faraday.new(
      url: "https://api.kroger.com/v1/",
      headers: {
        "Accept" => "application/json",
        "Authorization" => "Bearer #{location_token}"
      }
    )
  end

  def fetch_data(path, params = {})
    # Add caching around the response
    Rails.cache.fetch([:fetch_data, path, params], expires_in: 30.minutes) do
      response = connection.get(path) do |req|
        req.params = params unless params.empty?
      end
      response
    end
  end

  def fetch_location_data(path, params = {})
   
    Rails.cache.fetch([:fetch_location_data, path, params], expires_in: 1.minutes) do
      response = location_connection.get(path) do |req|
        req.params = params unless params.empty?
      end
      response
    end
  end
end
