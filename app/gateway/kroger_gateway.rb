class KrogerGateway
    @@token= nil
    @@token_expires_at = nil

    # def self.authorize_connection
    #     response = Faraday.post("https://api.kroger.com/v1/connect/oauth2/token") do |req|
    #         req.params = {
    #             scope: "product.compact",
    #             response_type: "code",
    #             client_id: Rails.application.credentials.kroger[:client_id],
    #             client_secret: Rails.application.credentials.kroger[:client_password],
    #             grant_type: "client_credentials"
    #         }
    #         req.headers = {
    #             "Cache-Control" => "no-cache",
    #             "Content-Type" => "application/x-www-form-urlencoded"
    #         }
    #     end
    
    #     if response.success?
    #         data = JSON.parse(response.body)
    #         @@token = data["access_token"]
    #         @@token_expires_at = Time.now + data["expires_in"].to_i
    #     else
    #         raise "Authorization failed: #{response.body}"
    #     end
    # end
    def self.authorize_connection
        # Base64 encode the client_id and client_secret
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
          @@token = data["access_token"]
          @@token_expires_at = Time.now + data["expires_in"].to_i
        else
          raise "Authorization failed: #{response.body}"
        end
      end
    

    def self.token
        if @@token.nil? || Time.now >= @@token_expires_at
            self.authorize_connection
        end
        @@token
    end


    def self.connection()
        @connection = Faraday.new(
            url: "https://api.kroger.com/v1/",

            headers: {
                "Accept" => "application/json",
                "Authorization" => "Bearer #{self.token}"}
            )
    end

    def self.fetch_data(path, params = {})
        response = self.connection.get(path) do |req|
            req.params = params unless params.empty?
        end
    end
end