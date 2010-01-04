module GoogleMaps

require 'pp'
require 'uri'
require 'net/http'
require 'rubygems'
require 'json'

KEY   = "ABQIAAAA33LdtDapxLpK1y-7KvqQAhSpbr_YJ8LlxhUjJExVrrRs8W66CxR9-FAf750PJ1utZfR_UvWXQuMkrA"
MIN_ACCURACY = 6

class AccuracyException < RuntimeError
end

class ParsingException < RuntimeError
end

class RequestException < RuntimeError
end

# This method runs the FIRST address through the google maps object
def self.lookup(addr)

  # Remove hyphens...
  address = addr.gsub(/-/, '') 

  # If we end up with an empty address, throw an argument exception.
  raise ArgumentError, "Empty address!" if address.length < 5

  # Ask google to look it up
  query         = "http://maps.google.com/maps/geo?q=" << URI.escape(address) <<  "&output=json&sensor=false&key=" << KEY
  response      = Net::HTTP.get_response(URI.parse(query))
  json          = JSON.parse(response.body)
  status        = json["Status"]["code"]
  case status
    when 200 then json
    when 400 then raise RequestException, "Request could not be parsed: #{query}"
    when 500 then raise RequestException, "Server Error"
    when 601 then raise RequestException, "Empty/Incomplete Query #{query}"
    when 602 then raise RequestException, "Unknown Location: #{addr}"
    when 603 then raise RequestException, "Unavailable Address: #{addr}"
    when 610 then raise RequestException, "Invalid API Key: #{KEY}"
    when 620 then raise RequestException, "Request Limit Exceeded"
    else raise RequestException, "Unknown Status: #{status}"
  end

  pp json
  accuracy = json["Placemark"][0]["AddressDetails"]["Accuracy"].to_i
  raise AccuracyException, "Accuracy of #{accuracy} below accepted minimum" if accuracy < MIN_ACCURACY

  street      = "Unknown"
  city        = "Unknown"
  state       = "Unknown"
  postal_code = "Unknown"
  country     = "Unknown"
  coords      = "0,0,0"
  address     = "Unknown"

  coords      = json["Placemark"][0]["Point"]["coordinates"].join ","
  name        = json["name"]
  address     = json["Placemark"][0]["address"]

  placemark   = json["Placemark"][0]["AddressDetails"]["Country"]
  location    = json["Placemark"][0]["AddressDetails"]["Country"] 

  country     = placemark["CountryNameCode"]

  area        = {}
  # This generally contains the state or region. 
  if location["AdministrativeArea"]
    area      = location["AdministrativeArea"]
    state     = area["AdministrativeAreaName"]
  # This is used for small countries that dont have states
  elsif location["SubAdministrativeArea"]
    area      = location["SubAdministrativeArea"]
    state     = area["SubAdministrativeAreaName"]
  else 
    raise ParseException, "Couldn't determine state/region for #{addr}"
  end

  locality    = {}
  # Locality == City 
  if area["Locality"]
    locality    = area["Locality"]
  # We are part of a region or county.  
  elsif area["SubAdministrativeArea"]["Locality"]
    locality    = area["SubAdministrativeArea"]["Locality"]
    if area["SubAdministrativeArea"]["Locality"]["DependentLocality"]
      locality  = area["SubAdministrativeArea"]["Locality"]["DependentLocality"]
    end
  else
    raise ParseException, "Couldn't determine city/locale for #{addr}"
  end

  if locality["LocalityName"]
    city      = locality["LocalityName"]
  end

  if locality["PostalCode"]
    postal_code = locality["PostalCode"]["PostalCodeNumber"]
  end

  if locality["Thoroughfare"]
    street      = locality["Thoroughfare"]["ThoroughfareName"] 
  end
  
  return      {:street_address => street, :city => city, :state => state, :postal_code => postal_code, :country => country, :coordinates => coords, :name => name, :address => address}

end

end 

