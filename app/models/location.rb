class Location < ActiveRecord::Base
  include PhysicalAddress
  # Basic Attributes
  validates_presence_of :name, :street_address, :city, :state, :postal_code, :country
  validates_uniqueness_of :name, :address

  attr_accessible :address
  
  # Employee relationship
  has_many :employees
  
  # Convenience method for dealing with complete addresses
  def address
    "#{street_address}, #{city}, #{state} #{postal_code}, #{country}"  
  end
  
  def address=(address)
    # lookup the address via google
    addr                 = validate(address)
    self.street_address  = addr[0]
    self.city            = addr[1]
    self.state           = addr[2]
    self.postal_code     = addr[3]
    self.country         = addr[4]
  end

  # Find by address
  def Location.find_by_address(address)
    addr            = validate(address)
    street_address  = addr[0]
    city            = addr[1]
    state           = addr[2]
    postal_code     = addr[3]
    country         = addr[4]

    Location.find(:first, :conditions => {:street_address => street_address, :city => city, :state => state, :postal_code => postal_code, :country => country}) 
  end

end
