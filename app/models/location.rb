class Location < ActiveRecord::Base
  has_many :employees
  validates_uniqueness_of :name, :street_address
end
