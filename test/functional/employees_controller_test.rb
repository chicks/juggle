require 'test_helper'

class EmployeesControllerTest < ActionController::TestCase

  test "index" do
    get :index  
    assert_response :success  
    assert_not_nil assigns(:employees) 
  end
end
