require 'singleton'

class KrogerGateway
  include Singleton

  def initialize
    @token = nil
    @token_expires_at = nil
  end

  def authorize_connection
    client_id = Rails.application.credentials.kroger[:client_id]
    client_secret = Rails.application.credentials.kroger[:client_password]
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

    # Handle response and parse token
    if response.success?
      data = JSON.parse(response.body)
      @token = data["access_token"]
      @token_expires_at = Time.now + data["expires_in"].to_i
    else
      raise "Authorization failed: #{response.body}"
    end
  end

  def token
    if @token.nil? || Time.now >= @token_expires_at
      authorize_connection
    end
    @token
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

  def fetch_data(path, params = {})
    response = connection.get(path) do |req|
      req.params = params unless params.empty?
    end
    JSON.parse(response.body) if response.success?
  end
end