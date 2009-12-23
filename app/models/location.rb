class Location < ActiveRecord::Base
  include PhysicalAddress
  # Basic Attributes
  validates_presence_of :name, :street_address, :city, :state, :postal_code, :country
  validates_uniqueness_of :name, :address
  
  # Employee relationship
  has_many :employees
  
  # Convenience method for dealing with complete addresses
  def address
    addr = street_address + city + state + postal_code + country  
  end
  
  def address=(address)
    # lookup the address via google
    addr = validate(address)["Placemark"][0]["AddressDetails"]["Country"]
    street_address  = addr[0]
    city            = addr[1]
    state           = addr[2]
    postal_code     = addr[3]
    country         = addr[4]
  end
end
