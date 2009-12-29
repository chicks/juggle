require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  test "valid new address" do
    l = Location.find_or_create_by_address("2723 Lake Tahoe Blvd South Lake Tahoe, CA")
    assert_equal("South Lake Tahoe", l.city)
  end

  test "valid existing address" do
    a = Location.find_or_create_by_address("2723 Lake Tahoe Blvd South Lake Tahoe, CA")
    b = Location.find_or_create_by_address("2723 Lake Tahoe Boulevard South Lake Tahoe CA")
    assert_equal(a, b)
  end

  test "valid domestic address with suite" do
    a = Location.find_or_create_by_address("10050 North Wolfe Road SW2-130 Cupertino, CA 95014")
    assert_equal("10050 N Wolfe Rd SW2130", a.street_address)
  end

  test "valid Chinese address" do
    a = Location.find_or_create_by_address("26th Floor, Suite K-L, Suntong Infoport Plaza, 55 West Huaihai Road, Shanghai")
    assert_equal("55 West Huaihai Road", a.street_address)
  end

  test "incomplete address" do
    a = Location.find_or_create_by_address("63114 USA")
    assert_equal("Unknown", a.street_address)
  end

  test "valid German address" do 
    a = Location.find_or_create_by_address("Crusiusstrasse 12 Munich, Germany 80538")
    assert_equal("Crusiusstrasse 12",a.street_address)
  end

end
