module GoogleMaps

require 'pp'
require 'uri'
require 'net/http'
require 'rubygems'
require 'json'

KEY   = "ABQIAAAA33LdtDapxLpK1y-7KvqQAhSpbr_YJ8LlxhUjJExVrrRs8W66CxR9-FAf750PJ1utZfR_UvWXQuMkrA"
MIN_ACCURACY = 6

class AccuracyException < Exception
end

# This method runs the FIRST address through the google maps object
def self.lookup(addr)

  # Remove hyphens...
  address = addr.gsub(/-/, '') 

  # Ask google to look it up
  query         = "http://maps.google.com/maps/geo?q=" << URI.escape(address) <<  "&output=json&sensor=false&key=" << KEY
  response      = Net::HTTP.get_response(URI.parse(query))
  json          = JSON.parse(response.body)
  case json["Status"]["code"]
    when "200" then json
    when "500" then raise "G_GEO_SERVER_ERROR"
    when "601" then raise "G_GEO_MISSING_QUERY"
    when "602" then raise "G_GEO_UNKNOWN_ADDRESS"
    when "603" then raise "G_GEO_UNAVAILABLE_ADDRESS"
    when "610" then raise "G_GEO_BAD_KEY"
    when "620" then raise "G_GEO_TOO_MANY_QUERIES"
  end

  pp json
  accuracy = json["Placemark"][0]["AddressDetails"]["Accuracy"].to_i
  raise AccuracyException, "Accuracy of #{accuracy} below accepted minimum" if accuracy < MIN_ACCURACY

  coords      = json["Placemark"][0]["Point"]["coordinates"].join ","
  name        = json["name"]
  address     = json["Placemark"][0]["address"]

  placemark   = json["Placemark"][0]["AddressDetails"]["Country"]
  location    = json["Placemark"][0]["AddressDetails"]["Country"] 

  country     = placemark["CountryNameCode"]
  state       = location["AdministrativeArea"]["AdministrativeAreaName"]
  locality    = location["AdministrativeArea"]["SubAdministrativeArea"]["Locality"] 
  if locality["DependentLocality"]
    locality  = location["AdministrativeArea"]["SubAdministrativeArea"]["Locality"]["DependentLocality"]
  end
  city        = locality["LocalityName"]
  postal_code = locality["PostalCode"]["PostalCodeNumber"]
  street      = locality["Thoroughfare"]["ThoroughfareName"]
  
  return      {:street_address => street, :city => city, :state => state, :postal_code => postal_code, :country => country, :coordinates => coords, :name => name, :address => address}

end

end 

