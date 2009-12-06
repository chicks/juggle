class Location < ActiveRecord::Base
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
      
  end
end
