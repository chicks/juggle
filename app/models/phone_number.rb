class PhoneNumber < ActiveRecord::Base
  belongs_to :employee
  self.inheritance_column = :_type_disabled
end
