require 'tsv2class'

namespace :db do ; namespace :import do 
  
  def create_employee(employee, employees)
   
    manager     = Employee.find_by_name(employee.reports_to)
    department  = Department.find_by_name(employee.department)
    location    = Location.find_by_address()

    # If we don't have an employee record for the manager, we need to create one. 
    until manager.class == Employee
      m = employees.select {|emp| emp.name == employee.reports_to}[0]
      manager = create_employee(m, employees)
    end
    
    # Create any missing departments
    if department == nil
      department = Department.new
      department.name, department.number = employee.department.split(' - ')
      department.save     
    end
    
    # Create any missing locations
    if location == nil
      location = Location.new
      location.name = ""
      location.street_address =""
      location.city = ""
      location.state = ""
      location.postal_code = ""
      location.country = ""
    end
    
    e            = Employee.new
    e            = Employee.find_by_name(employee.name)
    e.name       = employee.name
    e.legal_name = employee.legal_name
    e.title      = employee.title
    e.status     = "Active"
    e.manager    = manager
    e.department = department
    e.location   = location
    e.start_of_employment = ""
    e.end_of_employment   = ""
    e.save
    
  end

  desc "Import Employee Information from import/employees.tsv into database"
  task(:employees => :environment) do
    STDOUT.sync = true
    employees = Tsv2Class.new("import/employees.tsv")
    employees.each do |e|
    end
  end

end;end
