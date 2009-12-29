class Location < ActiveRecord::Base

  #
  # A location represents a physical residence, with an address.  
  # 
  # This model object contains methods for looking up a location 
  # against an external mapping resource, such as google maps.
  # Additionally, it contains an alias table which lets you assign
  # multiple names to a physical address.     
  #
  
  require 'pp'

  # Basic Attributes
  validates_presence_of :name, :street_address, :city, :state, :postal_code, :country, :coordinates
  validates_uniqueness_of :name, :coordinates

  attr_accessible :name, :street_address, :city, :state, :postal_code, :country, :coordinates, :address
  
  # Employee relationship
  has_many :employees

  # Location Alias relationship
  has_many :aliases, :class_name => "LocationAlias", :foreign_key => "location_id" 
  
  # Convenience method for dealing with complete addresses
  def address
    "#{self.street_address}, #{self.city}, #{self.state} #{self.postal_code}, #{self.country}"
  end
  
  def address=(addr, options={})
    self.street_address   = addr[:street_address]
    self.city             = addr[:city]
    self.state            = addr[:state]
    self.postal_code      = addr[:postal_code]
    self.country          = addr[:country]
    self.coordinates      = addr[:coordinates]
    self.name             = addr[:address]
  end

  # Query or Create by raw address.  This will query google.
  def Location.find_or_create_by_address(address)

    # Check for similar names first
    l = Location.find_by_name(address)

    # Check aliases, if not create a new entry.
    unless l
      l_alias = LocationAlias.find_by_name(address)
      if l_alias 
        l = l_alias.location
      else 
        # Lookup the address in google.  Use the coordinates to
        # see if this location already exists
        addr = Hash.new
        begin
          addr = GoogleMaps.lookup(address)
        rescue GoogleMaps::AccuracyException
          # The address we submitted didn't return a strong result
          # Assign this location to the "Unknown" object   
          addr[:coordinates] = "0,0,0"
        end
        l = Location.find_by_coordinates(addr[:coordinates])
        if l
          # This address already exists, create an alias
          l_alias = LocationAlias.new(:name => address, :location => l)
          l_alias.save
        else
          # Create a new location
          l = Location.new
          l.address = addr
          l.save
        end 
      end
    end

    return l
  end

end
