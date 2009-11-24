require 'test_helper'

class EmployeeTest < ActiveSupport::TestCase

  test "has manager" do
    assert_equal(Employee.find_by_name("Igor Spivak"), Employee.first.manager)
  end
  
  test "has subordinates" do
    assert_equal(Employee.first, Employee.find_by_name("Igor Spivak").subordinates[0])
  end
  
  test "has department" do
    assert_equal(Department.first, Employee.first.department)
  end
  
end
