# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091123225742) do

  create_table "departments", :force => true do |t|
    t.string   "name"
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "email_addresses", :force => true do |t|
    t.string   "address"
    t.boolean  "is_primary"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "email_addresses", ["employee_id"], :name => "index_email_addresses_on_employee_id"

  create_table "employees", :force => true do |t|
    t.string   "name"
    t.string   "legal_name"
    t.string   "title"
    t.string   "status"
    t.date     "start_of_employment"
    t.date     "end_of_employment"
    t.integer  "manager_id"
    t.integer  "department_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "employees", ["department_id"], :name => "index_employees_on_department_id"
  add_index "employees", ["location_id"], :name => "index_employees_on_location_id"
  add_index "employees", ["manager_id"], :name => "index_employees_on_manager_id"

  create_table "im_handles", :force => true do |t|
    t.string   "name"
    t.string   "provider"
    t.boolean  "is_primary"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "im_handles", ["employee_id"], :name => "index_im_handles_on_employee_id"

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_numbers", :force => true do |t|
    t.string   "number"
    t.string   "type"
    t.boolean  "is_primary"
    t.integer  "employee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "phone_numbers", ["employee_id"], :name => "index_phone_numbers_on_employee_id"

end
