module Employee

BASE        = "dc=sugarcrm, dc=net"
COMPANY     = "SugarCRM Inc."

class Address
  attr :type, true
  attr :street, true
  attr :unit, true
  attr :city, true
  attr :state, true
  attr :postal_code, true
  attr :country, true

  def initialize(type, street, unit, city, state, postal_code, country)
    @type   = type
    @street = street
    @unit   = unit
    @city   = city
    @state  = state
    @postal_code = postal_code
    @country = country
  end
  
end

class Department
  attr :name, true
  attr :number, true
end

class Employee
  attr :name, true
  attr :legal_name, true
  attr :title, true
  attr :manager, true
  attr :department, true
  attr :region, true
  attr :office, true
  attr :address, true

  def initialize()
  end

  def given_name
    @legal_name.split[0]
  end

  def first_name
    @name.split[0]
  end

  def last_name
    @name.split[-1]
  end

  def to_s
    "#{@legal_name}"
  end

  protected

    def user_name!
      @user_name = (first_name[0,1] + last_name).downcase
    end

end


class ActiveDirectory
  require 'rubygems'
  require 'net/ldap'

  HOST = "10.8.1.101"
  PORT = "389"
  USER = "CN=Charles Hicks Admin,OU=CUP1,OU=Domain Admins,DC=sugarcrm,DC=net"
  PASS = "99r3db@l"

  attr :connection, true
  attr :connected, true

  def initialize()
    connect!   
  end

  def connected?
    return false if @connection.nil? 
    return true if @connected
    @connected = @connection.bind
  end

  def find_by_filter(filter)
    ad = ActiveDirectory.new
    if ad.connected?
      return ad.connection.search( :base => BASE, :filter => filter, :return_result => true )
    else
      raise Exception, "No Connection"
    end
  end

  def self.find_by_name(name)
    ad = ActiveDirectory.new
    filter = Net::LDAP::Filter.eq( "CN", name )
    ad.find_by_filter(filter)
  end

  def self.find_first_by_name(name)
    self.find_by_name(name)[0]
  end
  
  def self.find_by_email(email)
    ad = ActiveDirectory.new
    filter = Net::LDAP::Filter.eq( "proxyaddresses", "*#{email}*" )
    ad.find_by_filter(filter)
  end
  
  def self.find_first_by_email(email)
    self.find_by_email(email)[0]
  end

  def self.update(employee)
    attr = {
      :objectclass => ["top", "person", "organizationalPerson", "user"],
      :cn     => employee.name,
      :sn     => employee.last_name,
      :c      => employee.country,
      :l      => employee.city,
      :postalCode => employee.postal_code,
      :title  => employee.title,
      :description => employee.title,
      :givenName => employee.given_name,
      :displayName => employee.name,
      :department => employee.department,
      :company => COMPANY,
      :name => employee.name,
      :manager => Employee::ActiveDirectory.find_first_by_name(employee.manager).dn,
      :sAMAccountName => employee.user_name,
      :userPrincipalName => employee.user_name + "@sugarcrm.net"
    }

  end
    
  protected
    def connect!
      unless connected?
        @connection = Net::LDAP.new
        @connection.host = HOST
        @connection.port = PORT
        @connection.auth USER, PASS
      end
    end

end

end
