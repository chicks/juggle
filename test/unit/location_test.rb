require 'test_helper'

class LocationTest < ActiveSupport::TestCase
  test "valid address" do
    address = "2723 Lake Tahoe Blvd South Lake Tahoe, CA"
    l = Location.new
    l.address = address
    assert_equals(l.city, "South Lake Tahoe")
  end
end
