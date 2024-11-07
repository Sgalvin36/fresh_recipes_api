# app/services/locations_serializer.rb
class LocationsSerializer
  def self.format(locations_data)
    {
      data: locations_data.map do |location|
        {
          locationId: location["locationId"],
          storeNumber: location["storeNumber"],
          name: location["name"],
          address: {
            addressLine1: location["address"]["addressLine1"],
            city: location["address"]["city"],
            state: location["address"]["state"],
            zipCode: location["address"]["zipCode"],
            county: location["address"]["county"]
          },
          geolocation: {
            latitude: location["geolocation"]["latitude"],
            longitude: location["geolocation"]["longitude"]
          }
        }
      end
    }
  end
end
