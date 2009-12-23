require 'tsv2class'

namespace :db do ; namespace :import do 
  

  # 
  #  This is a big recursive method.  It will keep calling itself until it can resolve any missing employees.
  # Recursion is neccessary because you need to add an employee's manager before you add the employee, and I 
  # didn't want to enforce order in the import file       
  #   
  def create_employee(employee, employees)
   
    puts "Looking up: #{employee.name}"
    manager     = Employee.find_by_name(employee.reports_to)
    department  = Department.find_by_name(employee.department)
    location    = Location.find_by_address(employee.location)

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
      location.address = employee.location
      location.save
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
      create_employee(e, employees)
    end
  end

end;end
