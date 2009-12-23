module PhysicalAddress

require 'uri'
require 'net/http'
require 'rubygems'
require 'json'

KEY = "ABQIAAAA33LdtDapxLpK1y-7KvqQAhSpbr_YJ8LlxhUjJExVrrRs8W66CxR9-FAf750PJ1utZfR_UvWXQuMkrA"

# This method runs the address through the google maps object
def validate(address)
  url         = "http://maps.google.com/maps/geo?q=" << URI.escape(address) << "&key=" << KEY
  location    = JSON.parse(Net::HTTP.get_response(URI.parse(url)).body)["Placemark"][0]["AddressDetails"]["Country"]

  country     = location["CountryNameCode"]
  state       = location["AdministrativeArea"]["AdministrativeAreaName"]
  locality    = location["AdministrativeArea"]["SubAdministrativeArea"]["Locality"] 
  city        = locality["LocalityName"]
  postal_code = locality["PostalCode"]["PostalCodeNumber"]
  street      = locality["Thoroughfare"]["ThoroughfareName"]
  
  address     = [street, city, state, postal_code, country]
end

end

