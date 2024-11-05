class KrogerAPIService
    def self.authorize_connection
        @token = Faraday.new(
            url: "https://api.kroger.com/v1/connect/oauth2/authorize"
            params: {
                scope: "product.compact" ,
                response_type: "code",
                client_id: ,

            }
            headers: {
                "Cache-Control": "no-cache",
                "Content-Type": "application/x-www-form-urlencoded" 
            }
        )
    end


    def self.connection
        @connection = Faraday.new(
            url: "https://api.kroger.com/v1/products",
            params: { filter.locationId: 62000115},

            headers: {"Authorization" => "Bearer #{Rails.application.credentials.the_movie_db[:token]}"}
            )
    end

    def self.fetch_data(path, params = {})
        response = connection.get(path) do |req|
            req.params = params unless params.empty?
        end
    end
end