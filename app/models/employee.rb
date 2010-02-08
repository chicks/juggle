class Employee < ActiveRecord::Base
  # Basic Attributes
  validates_presence_of :name
  validates_presence_of :legal_name
  validates_presence_of :title
  validates_presence_of :status
  validates_presence_of :start_of_employment
  
  # Manager/Subordinate Relationship
  belongs_to :manager, :class_name => "Employee"
  has_many   :subordinates, :class_name => "Employee", :foreign_key => "manager_id"
  validates_presence_of :manager
   
  # Departments
  belongs_to :department
  validates_presence_of :department
 
  # Location
  belongs_to :location
  validates_presence_of :location
  
  # Contact Types
  has_many :email_addresses
  has_many :phone_numbers
  has_many :im_handles

  # This is really a tree structure
  acts_as_tree :foreign_key => :manager_id, :order => :name

  def given_name
    legal_name.split[0]
  end

  def first_name
    name.split[0]
  end

  def last_name
    name.split[-1]
  end

  # Alias for location
  def address
    location
  end

  def address=(address)
    location = address
  end

  # Convenience method for returning the primary phone number
  def phone_number
    number = PhoneNumber.new
    phone_numbers.each do |p| 
      number = p if p.is_primary
    end
    number
  end
  
  # Convenience method for returning the primary email address
  def email_address
    email = EmailAddress.new
    email_addresses.each do |e|
      email = e if e.is_primary
    end
    email
  end

  # Convenience method for returning the primary im handle
  def im_handle
    im = ImHandle.new
    im_handles.each do |i|
      im = i if i.is_primary 
    end
    im
  end
  
  def Employee.all
    Employee.find(:all, :conditions => {:status => "Active"})
  end
  
  def Employee.root
    Employee.find_by_name("Root")
  end  

end
