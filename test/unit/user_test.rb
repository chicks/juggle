require 'test_helper'

class UserTest < ActiveSupport::TestCase
  should have_and_belong_to_many :roles
  should have_and_belong_to_many :teams
end
